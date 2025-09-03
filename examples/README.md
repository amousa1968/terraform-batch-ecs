# AWS Batch ECS Fargate Terraform Module - Examples

This directory contains example usage of the `batch-ecs` Terraform module.

## Usage

1. Initialize Terraform:

```bash
terraform init
```

2. Validate the configuration:

```bash
terraform validate
```

3. Plan the deployment:

```bash
terraform plan
```

4. Apply the configuration:

```bash
terraform apply
```

## Variables

The example passes the following variables to the module:

- `cluster_name`: Name of the ECS cluster.
- `ecs_task_execution_role_name`: IAM role name for ECS task execution.
- `ecs_task_role_name`: IAM role name for ECS task.
- `task_family`: ECS task family name.
- `cpu`: CPU units for the ECS task.
- `memory`: Memory for the ECS task.
- `container_name`: Container name.
- `container_image`: Container image to use.
- `container_port`: Container port.
- `log_group_name`: CloudWatch log group name.
- `region`: AWS region.
- `service_name`: ECS service name.
- `desired_count`: Desired number of ECS service tasks.
- `private_subnet_ids`: List of private subnet IDs.
- `kms_key_arn`: ARN of the KMS key for encryption.
- `kms_encrypted_secret_arn`: ARN of the KMS encrypted secret.
- `s3_bucket_name`: S3 bucket name for ECS task access.
- `enable_eventbridge_rule`: Enable EventBridge rule for AWS Batch events (default: false).
- `eventbridge_rule_name`: Name of the EventBridge rule.
- `eventbridge_target_arn`: ARN of the target for EventBridge rule (e.g., SNS topic ARN).
- `enable_inspector`: Enable Amazon Inspector for container image scanning (default: false).
- `ecr_repository_arn`: ARN of the ECR repository to scan with Amazon Inspector.

## Notes

- The module creates AWS Batch resources using Fargate ECS type with minimal IAM roles and policies.
- TLS encryption is enabled for all data transmission in Batch job definitions.
- CloudWatch monitoring and alarms are configured for Batch job metrics.
- EventBridge rule and Amazon Inspector integration are optional and controlled via variables.



