variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "ecs_task_execution_role_name" {
  description = "Name of the ECS task execution IAM role"
  type        = string
}

variable "ecs_task_role_name" {
  description = "Name of the ECS task IAM role"
  type        = string
}

variable "task_family" {
  description = "Family name of the ECS task definition"
  type        = string
}

variable "cpu" {
  description = "CPU units for the ECS task"
  type        = string
}

variable "memory" {
  description = "Memory for the ECS task"
  type        = string
}

variable "container_name" {
  description = "Name of the container"
  type        = string
}

variable "container_image" {
  description = "Container image to use"
  type        = string
}

variable "container_port" {
  description = "Port exposed by the container"
  type        = number
}

variable "log_group_name" {
  description = "CloudWatch log group name"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "service_name" {
  description = "Name of the ECS service"
  type        = string
}

variable "desired_count" {
  description = "Desired number of ECS service tasks"
  type        = number
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "kms_key_arn" {
  description = "ARN of the KMS key"
  type        = string
  default     = ""
}

variable "kms_encrypted_secret_arn" {
  description = "ARN of the KMS encrypted secret"
  type        = string
  default     = ""
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = ""
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
