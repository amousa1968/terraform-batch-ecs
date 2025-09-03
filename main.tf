terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.0"
}

# ----------------------------------------
# AWS Batch Compute Environment (FARGATE)
# ----------------------------------------

# ECS Cluster
resource "aws_ecs_cluster" "ecs-batch" {
  name = var.cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# ECS Service
resource "aws_ecs_service" "ecs-batch" {
  count           = var.create_ecs_task_definition ? 1 : 0
  name            = var.service_name
  cluster         = aws_ecs_cluster.ecs-batch.id
  task_definition = aws_ecs_task_definition.ecs-batch[0].arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.private_subnet_ids
    assign_public_ip = false
    security_groups = var.security_group_ids
  }

  depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_role_policy]
}

# ------------------------------
# IAM roles and policies
# ------------------------------

# IAM Role for ECS Task Execution with least privilege
resource "aws_iam_role" "ecs_task_execution_role" {
  name = var.ecs_task_execution_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# IAM Role for ECS Task with least privilege
resource "aws_iam_role" "ecs_task_role" {
  name = var.ecs_task_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "ecs_task_policy" {
  name        = "${var.ecs_task_role_name}-policy"
  description = "Least privilege policy for ECS task"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:GenerateDataKey"
        ]
        Resource = var.kms_key_arn
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "arn:aws:s3:::${var.s3_bucket_name}/*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "ecs_task_policy_attach" {
  name       = "${var.ecs_task_role_name}-policy-attach"
  policy_arn = aws_iam_policy.ecs_task_policy.arn
  roles      = [aws_iam_role.ecs_task_role.name]
}

# --------------------------------------------------
# AWS Batch Compute Environment
# --------------------------------------------------

resource "aws_batch_compute_environment" "batch_compute_env" {
  compute_environment_name = var.batch_compute_environment_name

  compute_resources {
    type = "FARGATE"
    
    subnets = var.private_subnet_ids
    security_group_ids = var.security_group_ids
    
    max_vcpus = var.batch_max_vcpus
  }

  service_role = aws_iam_role.batch_service_role.arn
  type         = "MANAGED"
  state        = var.batch_compute_environment_state
}

# --------------------------------------------------
# AWS Batch Job Queue
# --------------------------------------------------

resource "aws_batch_job_queue" "batch_job_queue" {
  name     = var.batch_job_queue_name
  state    = var.batch_job_queue_state
  priority = var.batch_job_queue_priority

  compute_environments = [
    aws_batch_compute_environment.batch_compute_env.arn
  ]
}

# --------------------------------------------------
# AWS Batch Job Definition
# --------------------------------------------------

resource "aws_batch_job_definition" "batch_job_definition" {
  name = var.batch_job_definition_name
  type = "container"
  
  platform_capabilities = ["FARGATE"]
  
  container_properties = jsonencode({
    image       = var.batch_container_image
    jobRoleArn  = aws_iam_role.ecs_task_role.arn
    executionRoleArn = aws_iam_role.ecs_task_execution_role.arn
    
    resourceRequirements = [
      {
        type  = "VCPU"
        value = var.batch_job_vcpu
      },
      {
        type  = "MEMORY"
        value = var.batch_job_memory
      }
    ]
    
    environment = var.batch_job_environment
    
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = var.log_group_name
        "awslogs-region"        = var.region
        "awslogs-stream-prefix" = var.batch_job_log_prefix
      }
    }
    
    secrets = var.batch_job_secrets
    
    networkConfiguration = {
      assignPublicIp = var.batch_assign_public_ip
    }
    
    fargatePlatformConfiguration = {
      platformVersion = var.batch_fargate_platform_version
    }
  })

  timeout {
    attempt_duration_seconds = var.batch_job_timeout_seconds
  }

  retry_strategy {
    attempts = var.batch_job_retry_attempts
  }

  tags = var.batch_job_tags
}

# --------------------------------------------------
# IAM Role for AWS Batch Service
# --------------------------------------------------

resource "aws_iam_role" "batch_service_role" {
  name = var.batch_service_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "batch.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "batch_service_role_policy" {
  role       = aws_iam_role.batch_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"
}

# --------------------------------------------------
# TLS Compliance Fargate Batch Job (ECS Task Definition - Optional)
# --------------------------------------------------

# ECS Task Definition with TLS and KMS encryption for secrets (for ECS service)
resource "aws_ecs_task_definition" "ecs-batch" {
  count                    = var.create_ecs_task_definition ? 1 : 0
  family                   = var.task_family
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.container_image
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "TLS_ENABLED"
          value = "true"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = var.log_group_name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = var.container_name
        }
      }
      secrets = [
        {
          name      = "SECRET_KEY"
          valueFrom = var.kms_encrypted_secret_arn
        }
      ]
    }
  ])
}

# --------------------------------------------------
# Enable AWS logging for Batch API calls
# --------------------------------------------------

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "ecs-batch" {
  name              = var.log_group_name
  retention_in_days = 14
}

# GuardDuty Detector
resource "aws_guardduty_detector" "ecs-batch" {
  enable = true
}

# --------------------------------------------------
# Enable Amazon Inspector for container image scanning
# --------------------------------------------------

# Amazon Inspector for container image scanning
resource "aws_inspector2_enabler" "inspector" {
  count = var.enable_inspector ? 1 : 0
  account_ids = ["123456789012"]  # Replace with actual account ID when using real credentials
  resource_types = ["ECR"]
}

# Removed unsupported resource aws_inspector2_filter

resource "aws_inspector2_organization_configuration" "org_config" {
  count = var.enable_inspector ? 1 : 0

  auto_enable {
    ec2 = true
    ecr = true
  }
}


# data "aws_caller_identity" "current" {}

#---------------------------------------------------
### Enable EventBridge Rule for Batch Events ####
#---------------------------------------------------

# EventBridge Rule for AWS Batch Events
resource "aws_cloudwatch_event_rule" "batch_events_rule" {
  count       = var.enable_eventbridge_rule ? 1 : 0
  name        = var.eventbridge_rule_name
  description = "EventBridge rule to capture AWS Batch events"
  event_pattern = jsonencode({
    "source": [
      "aws.batch"
    ]
  })
}

resource "aws_cloudwatch_event_target" "batch_events_target" {
  count      = var.enable_eventbridge_rule ? 1 : 0
  rule       = aws_cloudwatch_event_rule.batch_events_rule[0].name
  target_id  = "batchEventsTarget"
  arn        = var.eventbridge_target_arn
}

resource "aws_iam_role" "eventbridge_invoke_role" {
  count = var.enable_eventbridge_rule ? 1 : 0
  name  = "${var.eventbridge_rule_name}-invoke-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "events.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "eventbridge_invoke_policy" {
  count = var.enable_eventbridge_rule ? 1 : 0
  name  = "${var.eventbridge_rule_name}-invoke-policy"
  role  = aws_iam_role.eventbridge_invoke_role[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "sns:Publish"
      Resource = var.eventbridge_target_arn
    }]
  })
}
