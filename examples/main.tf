provider "aws" {
  region = "us-east-1"
}

module "batch_ecs" {
  source = "../"

  cluster_name                = "example-fargate-cluster"
  ecs_task_execution_role_name = "example-ecsTaskExecutionRole"
  ecs_task_role_name          = "example-ecsTaskRole"
  task_family                 = "example-fargate-task-family"
  cpu                         = "256"
  memory                      = "512"
  container_name              = "app-container"
  container_image             = "amazonlinux"
  container_port              = 80
  log_group_name              = "/ecs/fargate"
  region                      = "us-east-1"
  service_name                = "fargate-service"
  desired_count               = 1
  private_subnet_ids          = []
  kms_key_arn                 = ""
  kms_encrypted_secret_arn    = ""
  s3_bucket_name              = ""

  enable_eventbridge_rule     = false
  eventbridge_rule_name       = "batch-events-rule"
  eventbridge_target_arn      = ""

  enable_inspector            = false
  ecr_repository_arn          = ""
}
