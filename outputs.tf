output "ecs_cluster_id" {
  description = "ECS cluster ID"
  value       = aws_ecs_cluster.ecs-batch.id
}

output "ecs_service_name" {
  description = "ECS service name"
  value       = aws_ecs_service.ecs-batch.name
}

output "ecs_task_definition_arn" {
  description = "ECS task definition ARN"
  value       = aws_ecs_task_definition.ecs-batch.arn
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
