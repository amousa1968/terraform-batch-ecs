# Data sources commented out for mock/testing scenarios
# Uncomment these when using real AWS credentials

# data "aws_subnets" "private" {
#   filter {
#     name   = "tag:Type"
#     values = ["private"]
#   }
# }

# data "aws_s3_bucket" "bucket" {
#   bucket = var.s3_bucket_name
# }

# data "aws_kms_key" "key" {
#   key_id = var.kms_key_arn
# }

# data "aws_iam_role" "ecs_task_execution_role" {
#   name = var.ecs_task_execution_role_name
# }

# data "aws_iam_role" "ecs_task_role" {
#   name = var.ecs_task_role_name
# }

# data "aws_caller_identity" "current" {}
