output "ecs_cluster_id" {
  description = "ID of the ECS cluster"
  value       = module.batch_ecs.ecs_cluster_id
}

output "ecs_service_name" {
  description = "Name of the ECS service"
  value       = module.batch_ecs.ecs_service_name
}

output "ecs_task_definition_arn" {
  description = "ARN of the ECS task definition"
  value       = module.batch_ecs.ecs_task_definition_arn
}
