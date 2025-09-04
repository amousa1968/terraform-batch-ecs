# Terraform AWS Batch ECS Module - Test Suite

This directory contains comprehensive pytest unit tests for the Terraform AWS Batch ECS module.

## Overview

The test suite validates:
- Terraform plan output against expected resource configurations
- Terraform validation and formatting
- GitHub Actions workflow configurations
- Module structure and file organization
- Resource attribute validation

## Test Structure

```
tests/
├── __init__.py                 # Test package initialization
├── conftest.py                 # Shared fixtures and configuration
├── test_terraform_plan.py      # Tests for terraform plan validation
├── test_terraform_validate.py  # Tests for terraform validate and fmt
├── test_github_actions.py      # Tests for GitHub Actions workflows
├── requirements.txt            # Test dependencies
├── pytest.ini                 # Pytest configuration
└── README.md                  # This file
```

## Prerequisites

- Python 3.8+
- Terraform 1.0+
- AWS CLI configured (for mock testing)
- pytest

## Installation

1. Install test dependencies:
```bash
pip install -r tests/requirements.txt
```

2. Ensure Terraform is installed and available in PATH

## Running Tests

### Run All Tests
```bash
pytest
```

### Run Specific Test Files
```bash
# Test terraform plan validation
pytest tests/test_terraform_plan.py

# Test terraform validation and formatting
pytest tests/test_terraform_validate.py

# Test GitHub Actions workflows
pytest tests/test_github_actions.py
```

### Run Tests with Coverage
```bash
pytest --cov=terraform/batch-ecs
```

### Run Tests in Verbose Mode
```bash
pytest -v
```

### Run Specific Test Classes/Methods
```bash
# Run specific test class
pytest tests/test_terraform_plan.py::TestTerraformPlan

# Run specific test method
pytest tests/test_terraform_plan.py::TestTerraformPlan::test_terraform_plan_success
```

## Test Categories

### Terraform Plan Tests (`test_terraform_plan.py`)
- Validates terraform plan execution
- Checks resource creation counts (15 resources)
- Validates specific resource configurations:
  - AWS Batch Compute Environment
  - AWS Batch Job Definition
  - AWS Batch Job Queue
  - ECS Cluster and Services
  - IAM Roles and Policies
  - CloudWatch Log Groups
  - Security configurations
  - Network configurations

### Terraform Validation Tests (`test_terraform_validate.py`)
- Validates terraform configuration syntax
- Checks terraform formatting compliance
- Verifies terraform initialization
- Confirms required files exist

### GitHub Actions Tests (`test_github_actions.py`)
- Validates workflow YAML syntax
- Checks workflow structure and triggers
- Verifies terraform action usage
- Confirms mock credential configuration
- Tests working directory settings

## Test Fixtures

### Shared Fixtures (`conftest.py`)
- `terraform_examples_dir`: Path to examples directory
- `terraform_init`: Ensures terraform is initialized
- `terraform_plan`: Runs terraform plan and captures output
- `terraform_validate`: Runs terraform validate
- `terraform_fmt_check`: Runs terraform fmt check
- `parsed_plan_output`: Parses plan output into structured data
- `expected_resources`: Expected resource definitions

## Expected Test Results

Based on the terraform plan output, tests expect:

### Resources Created (15 total)
1. `aws_batch_compute_environment.batch_compute_env`
2. `aws_batch_job_definition.batch_job_definition`
3. `aws_batch_job_queue.batch_job_queue`
4. `aws_cloudwatch_log_group.ecs-batch`
5. `aws_ecs_cluster.ecs-batch`
6. `aws_ecs_service.ecs-batch[0]`
7. `aws_ecs_task_definition.ecs-batch[0]`
8. `aws_guardduty_detector.ecs-batch`
9. `aws_iam_policy.ecs_task_policy`
10. `aws_iam_policy_attachment.ecs_task_policy_attach`
11. `aws_iam_role.batch_service_role`
12. `aws_iam_role.ecs_task_execution_role`
13. `aws_iam_role.ecs_task_role`
14. `aws_iam_role_policy_attachment.batch_service_role_policy`
15. `aws_iam_role_policy_attachment.ecs_task_execution_role_policy`

### Outputs
- `ecs_cluster_id`
- `ecs_service_name` = "fargate-service"
- `ecs_task_definition_arn`

## Configuration Validation

Tests validate the following configurations:
- Fargate platform capabilities
- Security groups and network settings
- Container definitions and environment variables
- Logging configurations
- IAM policies and roles
- Retry strategies and timeouts
- KMS and Secrets Manager integration

## Mock Testing

The test suite is designed to work with mock AWS credentials for safe testing without real AWS resources. The mock credentials are configured in the GitHub Actions workflows and examples directory.

## Continuous Integration

These tests are automatically run via GitHub Actions:
- On every push to main/master branches
- On pull requests
- With mock AWS credentials for safe testing
- In the examples directory for integration testing

## Troubleshooting

### Common Issues

1. **Terraform not found**: Ensure Terraform is installed and in PATH
2. **AWS credentials**: Tests use mock credentials, ensure they're configured
3. **Directory structure**: Ensure tests are run from the module root directory
4. **Dependencies**: Install test dependencies with `pip install -r tests/requirements.txt`

### Debug Mode
Run tests with debug output:
```bash
pytest -v -s --tb=long
```

## Contributing

When adding new tests:
1. Follow the existing naming conventions
2. Add appropriate docstrings
3. Use fixtures for shared setup/teardown
4. Include assertions for both positive and negative cases
5. Update this README if adding new test categories

## Test Coverage

The test suite provides comprehensive coverage of:
- ✅ Terraform plan validation
- ✅ Resource configuration validation
- ✅ GitHub Actions workflow validation
- ✅ Module structure validation
- ✅ Security and network configuration validation
- ✅ IAM and logging configuration validation
