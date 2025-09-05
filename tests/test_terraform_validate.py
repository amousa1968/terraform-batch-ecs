import pytest


class TestTerraformValidate:
    """Test cases for Terraform validation"""

    def test_terraform_validate_success(self, terraform_validate):
        """Test that terraform validate executes successfully"""
        stdout, stderr, returncode = terraform_validate
        assert returncode == 0, f"Terraform validate failed: {stderr}"
        assert "Success!" in stdout or "The configuration is valid" in stdout or returncode == 0
        print("test_terraform_validate_success passed")

    def test_terraform_validate_no_errors(self, terraform_validate):
        """Test that terraform validate produces no errors"""
        stdout, stderr, returncode = terraform_validate
        assert returncode == 0, f"Validation failed with errors: {stderr}"
        # Ensure no error messages in stderr
        assert not stderr.strip() or "Success!" in stderr, f"Unexpected error in stderr: {stderr}"
        print("test_terraform_validate_no_errors passed")

def pytest_terminal_summary(terminalreporter, exitstatus, config):
    passed = len(terminalreporter.stats.get('passed', []))
    failed = len(terminalreporter.stats.get('failed', []))
    terminalreporter.write_sep("=", f"Test Summary: {passed} passed, {failed} failed")


class TestTerraformFormat:
    """Test cases for Terraform formatting"""

    def test_terraform_fmt_check_success(self, terraform_fmt_check):
        """Test that terraform fmt check passes"""
        stdout, stderr, returncode = terraform_fmt_check
        assert returncode == 0, f"Terraform fmt check failed: {stderr}"
        # If returncode is 0, formatting is correct
        assert not stdout.strip(), f"Files need formatting: {stdout}"


class TestTerraformInit:
    """Test cases for Terraform initialization"""

    def test_terraform_init_success(self, terraform_init):
        """Test that terraform init has been executed successfully"""
        # This test passes if the terraform_init fixture doesn't fail
        assert True

    def test_terraform_lock_file_exists(self, terraform_examples_dir):
        """Test that .terraform.lock.hcl file exists after init"""
        lock_file = terraform_examples_dir / ".terraform.lock.hcl"
        assert lock_file.exists(), ".terraform.lock.hcl should exist after terraform init"

    def test_terraform_directory_exists(self, terraform_examples_dir):
        """Test that .terraform directory exists after init"""
        terraform_dir = terraform_examples_dir / ".terraform"
        assert terraform_dir.exists() and terraform_dir.is_dir(), ".terraform directory should exist after terraform init"


class TestConfigurationFiles:
    """Test cases for configuration file validation"""

    def test_main_tf_exists(self, terraform_examples_dir):
        """Test that main.tf exists"""
        main_tf = terraform_examples_dir / "main.tf"
        assert main_tf.exists(), "main.tf should exist in examples directory"

    def test_variables_tf_exists(self, terraform_examples_dir):
        """Test that variables.tf exists"""
        variables_tf = terraform_examples_dir / "variables.tf"
        assert variables_tf.exists(), "variables.tf should exist in examples directory"

    def test_terraform_tfvars_exists(self, terraform_examples_dir):
        """Test that terraform.tfvars exists"""
        tfvars = terraform_examples_dir / "terraform.tfvars"
        assert tfvars.exists(), "terraform.tfvars should exist in examples directory"

    def test_mock_credentials_exists(self, terraform_examples_dir):
        """Test that mock-credentials.tf exists"""
        mock_creds = terraform_examples_dir.parent / "mock-credentials.tf"
        assert mock_creds.exists(), "mock-credentials.tf should exist in root directory"


class TestResourceValidation:
    """Test cases for resource validation in plan output"""

    def test_batch_resources_in_plan(self, terraform_plan):
        """Test that Batch resources are present in plan"""
        stdout, stderr, returncode = terraform_plan
        assert "aws_batch_compute_environment" in stdout
        assert "aws_batch_job_definition" in stdout
        assert "aws_batch_job_queue" in stdout

    def test_ecs_resources_in_plan(self, terraform_plan):
        """Test that ECS resources are present in plan"""
        stdout, stderr, returncode = terraform_plan
        assert "aws_ecs_cluster" in stdout
        assert "aws_ecs_service" in stdout
        assert "aws_ecs_task_definition" in stdout

    def test_iam_resources_in_plan(self, terraform_plan):
        """Test that IAM resources are present in plan"""
        stdout, stderr, returncode = terraform_plan
        assert "aws_iam_role" in stdout
        assert "aws_iam_policy" in stdout

    def test_monitoring_resources_in_plan(self, terraform_plan):
        """Test that monitoring resources are present in plan"""
        stdout, stderr, returncode = terraform_plan
        assert "aws_cloudwatch_log_group" in stdout
        assert "aws_guardduty_detector" in stdout

    def test_fargate_platform_capabilities(self, terraform_plan):
        """Test that Fargate platform capabilities are configured"""
        stdout, stderr, returncode = terraform_plan
        assert '"FARGATE"' in stdout
        assert "platform_capabilities" in stdout

    def test_security_configurations(self, terraform_plan):
        """Test that security configurations are present"""
        stdout, stderr, returncode = terraform_plan
        assert "security_group_ids" in stdout
        assert "assign_public_ip = false" in stdout

    def test_network_configurations(self, terraform_plan):
        """Test that network configurations are present"""
        stdout, stderr, returncode = terraform_plan
        assert "network_configuration" in stdout
        assert "subnets" in stdout

    def test_container_definitions(self, terraform_plan):
        """Test that container definitions are properly configured"""
        stdout, stderr, returncode = terraform_plan
        assert "container_definitions" in stdout
        assert "image" in stdout
        assert "portMappings" in stdout

    def test_logging_configurations(self, terraform_plan):
        """Test that logging configurations are present"""
        stdout, stderr, returncode = terraform_plan
        assert "logConfiguration" in stdout
        assert "awslogs" in stdout

    def test_environment_variables(self, terraform_plan):
        """Test that environment variables are configured"""
        stdout, stderr, returncode = terraform_plan
        assert "environment" in stdout
        assert "TLS_ENABLED" in stdout

    def test_retry_strategies(self, terraform_plan):
        """Test that retry strategies are configured"""
        stdout, stderr, returncode = terraform_plan
        assert "retry_strategy" in stdout
        assert "attempts" in stdout

    def test_timeout_configurations(self, terraform_plan):
        """Test that timeout configurations are present"""
        stdout, stderr, returncode = terraform_plan
        assert "timeout" in stdout
        assert "attempt_duration_seconds" in stdout
