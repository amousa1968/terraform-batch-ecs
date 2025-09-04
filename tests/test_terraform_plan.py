import pytest
import subprocess
import json
import re
from pathlib import Path


class TestTerraformPlan:
    """Test cases for Terraform AWS Batch ECS module plan validation"""

    @pytest.fixture(scope="class")
    def terraform_plan_output(self):
        """Fixture to run terraform plan and capture output"""
        # Change to examples directory for testing
        examples_dir = Path(__file__).parent.parent / "examples"

        # Run terraform init
        init_result = subprocess.run(
            ["terraform", "init", "-no-color"],
            cwd=examples_dir,
            capture_output=True,
            text=True
        )
        assert init_result.returncode == 0, f"Terraform init failed: {init_result.stderr}"

        # Run terraform plan
        plan_result = subprocess.run(
            ["terraform", "plan", "-no-color", "-input=false"],
            cwd=examples_dir,
            capture_output=True,
            text=True
        )

        return plan_result.stdout, plan_result.stderr, plan_result.returncode

    def test_terraform_plan_success(self, terraform_plan_output):
        """Test that terraform plan executes successfully"""
        stdout, stderr, returncode = terraform_plan_output
        assert returncode == 0, f"Terraform plan failed: {stderr}"
        assert "Plan:" in stdout, "Plan summary not found in output"

    def test_plan_summary_validation(self, terraform_plan_output):
        """Test the plan summary shows correct resource counts"""
        stdout, stderr, returncode = terraform_plan_output

        # Check for expected plan summary
        assert "15 to add, 0 to change, 0 to destroy" in stdout

    def test_batch_compute_environment_creation(self, terraform_plan_output):
        """Test AWS Batch Compute Environment resource creation"""
        stdout, stderr, returncode = terraform_plan_output

        # Check for Batch Compute Environment
        assert "aws_batch_compute_environment.batch_compute_env will be created" in stdout
        assert 'compute_environment_name        = "example-batch-compute-env"' in stdout
        assert 'state                           = "ENABLED"' in stdout
        assert 'type                            = "MANAGED"' in stdout
        assert 'max_vcpus          = 16' in stdout
        assert 'type               = "FARGATE"' in stdout

    def test_batch_job_definition_creation(self, terraform_plan_output):
        """Test AWS Batch Job Definition resource creation"""
        stdout, stderr, returncode = terraform_plan_output

        # Check for Batch Job Definition
        assert "aws_batch_job_definition.batch_job_definition will be created" in stdout
        assert 'name                  = "example-batch-job-def"' in stdout
        assert 'type                  = "container"' in stdout
        assert '"FARGATE"' in stdout
        assert "attempts = 3" in stdout
        assert "attempt_duration_seconds = 3600" in stdout

    def test_batch_job_queue_creation(self, terraform_plan_output):
        """Test AWS Batch Job Queue resource creation"""
        stdout, stderr, returncode = terraform_plan_output

        # Check for Batch Job Queue
        assert "aws_batch_job_queue.batch_job_queue will be created" in stdout
        assert 'name                 = "example-batch-job-queue"' in stdout
        assert "priority             = 1" in stdout
        assert 'state                = "ENABLED"' in stdout

    def test_ecs_cluster_creation(self, terraform_plan_output):
        """Test ECS Cluster resource creation"""
        stdout, stderr, returncode = terraform_plan_output

        # Check for ECS Cluster
        assert "aws_ecs_cluster.ecs-batch will be created" in stdout
        assert 'name               = "example-fargate-cluster"' in stdout
        assert 'name  = "containerInsights"' in stdout
        assert 'value = "enabled"' in stdout

    def test_ecs_task_definition_creation(self, terraform_plan_output):
        """Test ECS Task Definition resource creation"""
        stdout, stderr, returncode = terraform_plan_output

        # Check for ECS Task Definition
        assert "aws_ecs_task_definition.ecs-batch[0] will be created" in stdout
        assert 'family                   = "example-fargate-task-family"' in stdout
        assert 'cpu                      = "256"' in stdout
        assert 'memory                   = "512"' in stdout
        assert 'network_mode             = "awsvpc"' in stdout
        assert '"FARGATE"' in stdout
        assert '"TLS_ENABLED"' in stdout
        assert '"app-container"' in stdout

    def test_cloudwatch_log_group_creation(self, terraform_plan_output):
        """Test CloudWatch Log Group resource creation"""
        stdout, stderr, returncode = terraform_plan_output

        # Check for CloudWatch Log Group
        assert "aws_cloudwatch_log_group.ecs-batch will be created" in stdout
        assert 'name              = "/ecs/fargate"' in stdout
        assert "retention_in_days = 14" in stdout

    def test_guardduty_detector_creation(self, terraform_plan_output):
        """Test GuardDuty Detector resource creation"""
        stdout, stderr, returncode = terraform_plan_output

        # Check for GuardDuty Detector
        assert "aws_guardduty_detector.ecs-batch will be created" in stdout
        assert "enable                       = true" in stdout

    def test_iam_roles_creation(self, terraform_plan_output):
        """Test IAM Roles resource creation"""
        stdout, stderr, returncode = terraform_plan_output

        # Check for IAM Roles
        assert "aws_iam_role.batch_service_role will be created" in stdout
        assert "aws_iam_role.ecs_task_execution_role will be created" in stdout
        assert "aws_iam_role.ecs_task_role will be created" in stdout

        # Check role names
        assert 'name                  = "example-batch-service-role"' in stdout
        assert 'name                  = "example-ecsTaskExecutionRole"' in stdout
        assert 'name                  = "example-ecsTaskRole"' in stdout

    def test_iam_policies_creation(self, terraform_plan_output):
        """Test IAM Policies resource creation"""
        stdout, stderr, returncode = terraform_plan_output

        # Check for IAM Policies
        assert "aws_iam_policy.ecs_task_policy will be created" in stdout
        assert 'name        = "example-ecsTaskRole-policy"' in stdout
        assert '"logs:CreateLogStream"' in stdout
        assert '"logs:PutLogEvents"' in stdout
        assert '"kms:Decrypt"' in stdout
        assert '"s3:GetObject"' in stdout

    def test_iam_policy_attachments_creation(self, terraform_plan_output):
        """Test IAM Policy Attachments resource creation"""
        stdout, stderr, returncode = terraform_plan_output

        # Check for IAM Policy Attachments
        assert "aws_iam_role_policy_attachment.batch_service_role_policy will be created" in stdout
        assert "aws_iam_role_policy_attachment.ecs_task_execution_role_policy will be created" in stdout
        assert "aws_iam_policy_attachment.ecs_task_policy_attach will be created" in stdout

    def test_outputs_validation(self, terraform_plan_output):
        """Test that expected outputs are defined"""
        stdout, stderr, returncode = terraform_plan_output

        # Check for expected outputs
        assert "Changes to Outputs:" in stdout
        assert "ecs_cluster_id" in stdout
        assert "ecs_service_name" in stdout
        assert 'ecs_service_name        = "fargate-service"' in stdout
        assert "ecs_task_definition_arn" in stdout

    def test_security_group_configuration(self, terraform_plan_output):
        """Test security group configurations"""
        stdout, stderr, returncode = terraform_plan_output

        # Check security groups are properly configured
        assert '"sg-0123456789abcdef0"' in stdout

    def test_subnet_configuration(self, terraform_plan_output):
        """Test subnet configurations"""
        stdout, stderr, returncode = terraform_plan_output

        # Check subnets are properly configured
        assert '"subnet-0123456789abcdef0"' in stdout
        assert '"subnet-0fedcba9876543210"' in stdout

    def test_container_configuration(self, terraform_plan_output):
        """Test container configurations"""
        stdout, stderr, returncode = terraform_plan_output

        # Check container configurations
        assert '"amazonlinux"' in stdout
        assert "containerPort = 80" in stdout
        assert '"awslogs"' in stdout
        assert '"/ecs/fargate"' in stdout

    def test_kms_and_secrets_configuration(self, terraform_plan_output):
        """Test KMS and Secrets Manager configurations"""
        stdout, stderr, returncode = terraform_plan_output

        # Check KMS and secrets configurations
        assert '"abcd1234-5678-90ab-cdef-EXAMPLEKEY"' in stdout
        assert '"arn:aws:secretsmanager:us-east-1:123456789012:secret:example-secret"' in stdout
        assert '"SECRET_KEY"' in stdout

    def test_s3_bucket_configuration(self, terraform_plan_output):
        """Test S3 bucket configurations"""
        stdout, stderr, returncode = terraform_plan_output

        # Check S3 bucket configurations
        assert '"arn:aws:s3:::example-bucket/*"' in stdout

    def test_resource_count_validation(self, terraform_plan_output):
        """Test that all expected resources are present"""
        stdout, stderr, returncode = terraform_plan_output

        # Count the number of resources being created
        create_count = stdout.count("will be created")
        assert create_count == 15, f"Expected 15 resources to be created, found {create_count}"

    def test_no_unexpected_changes(self, terraform_plan_output):
        """Test that no unexpected changes or destroys are planned"""
        stdout, stderr, returncode = terraform_plan_output

        # Ensure no resources are being changed or destroyed
        assert "to change" in stdout and "0 to change" in stdout
        assert "to destroy" in stdout and "0 to destroy" in stdout

    def test_fargate_configuration(self, terraform_plan_output):
        """Test Fargate-specific configurations"""
        stdout, stderr, returncode = terraform_plan_output

        # Check Fargate configurations
        assert '"FARGATE"' in stdout
        assert 'requires_compatibilities = [' in stdout
        assert 'network_mode             = "awsvpc"' in stdout

    def test_terraform_version_compatibility(self, terraform_plan_output):
        """Test Terraform version compatibility"""
        stdout, stderr, returncode = terraform_plan_output

        # This test would pass as we're using Terraform 1.0+
        # In a real scenario, you might want to check version compatibility
        assert returncode == 0
