# Terraform variables for AWS Batch ECS module example
# These are example/mock values for testing purposes

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

private_subnet_ids = [
  "subnet-0123456789abcdef0",
  "subnet-0fedcba9876543210"
]

kms_key_arn                 = "arn:aws:kms:us-east-1:123456789012:key/abcd1234-5678-90ab-cdef-EXAMPLEKEY"
kms_encrypted_secret_arn    = "arn:aws:secretsmanager:us-east-1:123456789012:secret:example-secret"
s3_bucket_name              = "example-bucket"

enable_eventbridge_rule     = false
eventbridge_rule_name       = "batch-events-rule"
eventbridge_target_arn      = ""

enable_inspector            = false
ecr_repository_arn          = ""

batch_compute_environment_name  = "example-batch-compute-env"
batch_compute_environment_state = "ENABLED"
batch_max_vcpus                 = 16

batch_job_queue_name           = "example-batch-job-queue"
batch_job_queue_state          = "ENABLED"
batch_job_queue_priority       = 1

batch_job_definition_name      = "example-batch-job-def"
batch_container_image          = "amazonlinux"
batch_job_vcpu                 = "1"
batch_job_memory               = "2048"
batch_job_environment          = []
batch_job_secrets              = []
batch_job_log_prefix           = "batch-job"
batch_assign_public_ip         = "ENABLED"
batch_fargate_platform_version = "LATEST"
batch_job_timeout_seconds      = 3600
batch_job_retry_attempts       = 3
batch_job_tags                 = {}

batch_service_role_name        = "example-batch-service-role"
security_group_ids             = ["sg-0123456789abcdef0"]

create_ecs_task_definition     = true
