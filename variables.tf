variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "ECS cluster name"
  type        = string
  default     = "fargate-ecs-cluster"
}

variable "ecs_task_execution_role_name" {
  description = "IAM role name for ECS task execution"
  type        = string
  default     = "ecsTaskExecutionRole"
}

variable "ecs_task_role_name" {
  description = "IAM role name for ECS task"
  type        = string
  default     = "ecsTaskRole"
}

variable "kms_key_arn" {
  description = "KMS key ARN for encrypting secrets"
  type        = string
  default     = ""
}

variable "s3_bucket_name" {
  description = "S3 bucket name for ECS task access"
  type        = string
  default     = ""
}

variable "kms_encrypted_secret_arn" {
  description = "ARN of the KMS encrypted secret"
  type        = string
  default     = ""
}

variable "task_family" {
  description = "ECS task family name"
  type        = string
  default     = "fargate-task-family"
}

variable "cpu" {
  description = "CPU units for ECS task"
  type        = string
  default     = "256"
}

variable "memory" {
  description = "Memory for ECS task in MiB"
  type        = string
  default     = "512"
}

variable "container_name" {
  description = "Container name"
  type        = string
  default     = "app-container"
}

variable "container_image" {
  description = "Container image"
  type        = string
  default     = "amazonlinux"
}

variable "container_port" {
  description = "Container port"
  type        = number
  default     = 80
}

variable "log_group_name" {
  description = "CloudWatch log group name"
  type        = string
  default     = "/ecs/fargate"
}

variable "service_name" {
  description = "ECS service name"
  type        = string
  default     = "fargate-service"
}

variable "desired_count" {
  description = "Desired number of ECS service tasks"
  type        = number
  default     = 1
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
  default     = []
}

variable "enable_eventbridge_rule" {
  description = "Enable EventBridge rule for AWS Batch events"
  type        = bool
  default     = false
}

variable "eventbridge_rule_name" {
  description = "Name of the EventBridge rule"
  type        = string
  default     = "batch-events-rule"
}

variable "eventbridge_target_arn" {
  description = "ARN of the target for EventBridge rule (e.g., SNS topic ARN)"
  type        = string
  default     = ""
}

variable "enable_inspector" {
  description = "Enable Amazon Inspector for container image scanning"
  type        = bool
  default     = false
}

variable "ecr_repository_arn" {
  description = "ARN of the ECR repository to scan with Amazon Inspector"
  type        = string
  default     = ""
}
