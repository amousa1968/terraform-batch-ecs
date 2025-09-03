# AWS Batch Fargate ECS Terraform Module

This Terraform module provisions AWS Batch resources using Fargate ECS type with minimal IAM roles and policies, TLS encryption, CloudWatch monitoring, and GuardDuty enabled.

## Features

- AWS Batch Compute Environment using Fargate
- Batch Job Queue and Job Definition with TLS encryption enabled
- Minimal IAM roles for Batch jobs with condition-based access restrictions
- CloudWatch alarms for job failures and high CPU usage
- CloudWatch Container Insights enabled on ECS cluster
- GuardDuty threat detection enabled
- Example usage provided in the `examples` subdirectory

## Usage

See the `examples` directory for a sample Terraform configuration that calls this module.

## Inputs

Refer to the `variables.tf` file for all input variables and their descriptions.

## Outputs

Refer to the `outputs.tf` file for all output values.

## Notes

- This module does not create VPCs, subnets, security groups, or Lambda functions. These must be provided externally.
- Ensure you provide private subnet IDs for the ECS service network configuration.
- TLS encryption is enabled via environment variables in the container definition.
- IAM roles are created with least privilege and condition statements to restrict access.

## License

## CI/CD

This module includes GitHub Actions workflows for automated testing and validation:

### Workflows

1. **terraform.yml**: Main workflow that runs on pushes and PRs to main/master branches
   - Terraform format check
   - Terraform validation
   - Terraform init and plan
   - Updates PR with results

2. **terraform-mock.yml**: Mock testing workflow using test AWS credentials
   - Runs format, validate, init, and plan with mock credentials
   - Safe for testing without real AWS resources

3. **terraform-examples.yml**: Tests the example configurations
   - Runs in the `examples/` directory
   - Validates the example usage works correctly

### Mock Testing

The mock testing workflows use test AWS credentials to validate the Terraform configuration without requiring real AWS resources. This is useful for:

- Pull request validation
- Development testing
- CI/CD pipelines
- Code quality checks


## Terraform Commands

To initialize the Terraform working directory:

```bash
terraform init
```

To validate the Terraform configuration files:

```bash
terraform validate
```

To see the execution plan before applying changes:

```bash
terraform plan
```

To apply the Terraform configuration and create resources:

```bash
terraform apply
```

To destroy the created resources:

```bash
terraform destroy
```
