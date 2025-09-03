output "ecs_cluster_id" {
  description = "ECS cluster ID"
  value       = aws_ecs_cluster.ecs-batch.id
}

output "ecs_service_name" {
  description = "ECS service name"
  value       = var.create_ecs_task_definition ? aws_ecs_service.ecs-batch[0].name : null
}

output "ecs_task_definition_arn" {
  description = "ECS task definition ARN"
  value       = var.create_ecs_task_definition ? aws_ecs_task_definition.ecs-batch[0].arn : null
}

output "ecs_task_execution_role_arn" {
  description = "IAM role ARN for ECS task execution"
  value       = aws_iam_role.ecs_task_execution_role.arn
}

output "ecs_task_role_arn" {
  description = "IAM role ARN for ECS task"
  value       = aws_iam_role.ecs_task_role.arn
}

output "cloudwatch_log_group_name" {
  description = "CloudWatch log group name"
  value       = aws_cloudwatch_log_group.ecs-batch.name
}

output "guardduty_detector_id" {
  description = "GuardDuty detector ID"
  value       = aws_guardduty_detector.ecs-batch.id
}

# AWS Batch Outputs
output "batch_compute_environment_arn" {
  description = "ARN of the AWS Batch compute environment"
  value       = aws_batch_compute_environment.batch_compute_env.arn
}

output "batch_compute_environment_name" {
  description = "Name of the AWS Batch compute environment"
  value       = aws_batch_compute_environment.batch_compute_env.compute_environment_name
}

output "batch_job_queue_arn" {
  description = "ARN of the AWS Batch job queue"
  value       = aws_batch_job_queue.batch_job_queue.arn
}

output "batch_job_queue_name" {
  description = "Name of the AWS Batch job queue"
  value       = aws_batch_job_queue.batch_job_queue.name
}

output "batch_job_definition_arn" {
  description = "ARN of the AWS Batch job definition"
  value       = aws_batch_job_definition.batch_job_definition.arn
}

output "batch_job_definition_name" {
  description = "Name of the AWS Batch job definition"
  value       = aws_batch_job_definition.batch_job_definition.name
}

output "batch_service_role_arn" {
  description = "ARN of the IAM role for AWS Batch service"
  value       = aws_iam_role.batch_service_role.arn
}
