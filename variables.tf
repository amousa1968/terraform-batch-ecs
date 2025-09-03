variable "region" {
  description = "AWS region"
  type        = string
}

variable "cluster_name" {
  description = "ECS cluster name"
  type        = string
}

variable "ecs_task_execution_role_name" {
  description = "IAM role name for ECS task execution"
  type        = string
}

variable "ecs_task_role_name" {
  description = "IAM role name for ECS task"
  type        = string
}

variable "kms_key_arn" {
  description = "KMS key ARN for encrypting secrets"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 bucket name for ECS task access"
  type        = string
}

variable "kms_encrypted_secret_arn" {
  description = "ARN of the KMS encrypted secret"
  type        = string
}

variable "task_family" {
  description = "ECS task family name"
  type        = string
}

variable "cpu" {
  description = "CPU units for ECS task"
  type        = string
}

variable "memory" {
  description = "Memory for ECS task in MiB"
  type        = string
}

variable "container_name" {
  description = "Container name"
  type        = string
}

variable "container_image" {
  description = "Container image"
  type        = string
}

variable "container_port" {
  description = "Container port"
  type        = number
}

variable "log_group_name" {
  description = "CloudWatch log group name"
  type        = string
}

variable "service_name" {
  description = "ECS service name"
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

variable "enable_eventbridge_rule" {
  description = "Enable EventBridge rule for AWS Batch events"
  type        = bool
}

variable "eventbridge_rule_name" {
  description = "Name of the EventBridge rule"
  type        = string
}

variable "eventbridge_target_arn" {
  description = "ARN of the target for EventBridge rule (e.g., SNS topic ARN)"
  type        = string
}

variable "enable_inspector" {
  description = "Enable Amazon Inspector for container image scanning"
  type        = bool
}

variable "ecr_repository_arn" {
  description = "ARN of the ECR repository to scan with Amazon Inspector"
  type        = string
}

# AWS Batch Variables
variable "batch_compute_environment_name" {
  description = "Name of the AWS Batch compute environment"
  type        = string
}

variable "batch_compute_environment_state" {
  description = "State of the AWS Batch compute environment (ENABLED or DISABLED)"
  type        = string
}

variable "batch_max_vcpus" {
  description = "Maximum vCPUs for the AWS Batch compute environment"
  type        = number
}

variable "batch_job_queue_name" {
  description = "Name of the AWS Batch job queue"
  type        = string
}

variable "batch_job_queue_state" {
  description = "State of the AWS Batch job queue (ENABLED or DISABLED)"
  type        = string
}

variable "batch_job_queue_priority" {
  description = "Priority of the AWS Batch job queue"
  type        = number
}

variable "batch_job_definition_name" {
  description = "Name of the AWS Batch job definition"
  type        = string
}

variable "batch_container_image" {
  description = "Container image for the AWS Batch job"
  type        = string
}

variable "batch_job_vcpu" {
  description = "vCPU units for the AWS Batch job"
  type        = string
}

variable "batch_job_memory" {
  description = "Memory for the AWS Batch job in MiB"
  type        = string
}

variable "batch_job_environment" {
  description = "Environment variables for the AWS Batch job"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "batch_job_secrets" {
  description = "Secrets for the AWS Batch job"
  type = list(object({
    name      = string
    valueFrom = string
  }))
  default = []
}

variable "batch_job_log_prefix" {
  description = "Log stream prefix for AWS Batch job"
  type        = string
}

variable "batch_assign_public_ip" {
  description = "Whether to assign public IP to AWS Batch job"
  type        = string
}

variable "batch_fargate_platform_version" {
  description = "Fargate platform version for AWS Batch job"
  type        = string
}

variable "batch_job_timeout_seconds" {
  description = "Timeout in seconds for AWS Batch job"
  type        = number
}

variable "batch_job_retry_attempts" {
  description = "Number of retry attempts for AWS Batch job"
  type        = number
}

variable "batch_job_tags" {
  description = "Tags for AWS Batch job definition"
  type        = map(string)
  default     = {}
}

variable "batch_service_role_name" {
  description = "Name of the IAM role for AWS Batch service"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs for AWS Batch"
  type        = list(string)
}

variable "create_ecs_task_definition" {
  description = "Whether to create ECS task definition"
  type        = bool
  default     = false
}
