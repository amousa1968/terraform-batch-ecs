import pytest
import yaml
from pathlib import Path


class TestGitHubActionsWorkflows:
    """Test cases for GitHub Actions workflow validation"""

    @pytest.fixture(scope="class")
    def workflows_dir(self):
        """Fixture to get the workflows directory"""
        return Path(__file__).parent.parent / ".github" / "workflows"

    def test_workflows_directory_exists(self, workflows_dir):
        """Test that .github/workflows directory exists"""
        assert workflows_dir.exists(), ".github/workflows directory should exist"
        assert workflows_dir.is_dir(), ".github/workflows should be a directory"

    def test_terraform_workflow_exists(self, workflows_dir):
        """Test that terraform.yml workflow exists"""
        workflow_file = workflows_dir / "terraform.yml"
        assert workflow_file.exists(), "terraform.yml workflow should exist"

    def test_terraform_mock_workflow_exists(self, workflows_dir):
        """Test that terraform-mock.yml workflow exists"""
        workflow_file = workflows_dir / "terraform-mock.yml"
        assert workflow_file.exists(), "terraform-mock.yml workflow should exist"

    def test_terraform_examples_workflow_exists(self, workflows_dir):
        """Test that terraform-examples.yml workflow exists"""
        workflow_file = workflows_dir / "terraform-examples.yml"
        assert workflow_file.exists(), "terraform-examples.yml workflow should exist"

    def test_terraform_workflow_valid_yaml(self, workflows_dir):
        """Test that terraform.yml is valid YAML"""
        workflow_file = workflows_dir / "terraform.yml"
        with open(workflow_file, 'r', encoding='utf-8') as f:
            content = f.read()
            # Should not raise an exception if valid YAML
            yaml.safe_load(content)

    def test_terraform_mock_workflow_valid_yaml(self, workflows_dir):
        """Test that terraform-mock.yml is valid YAML"""
        workflow_file = workflows_dir / "terraform-mock.yml"
        with open(workflow_file, 'r', encoding='utf-8') as f:
            content = f.read()
            yaml.safe_load(content)

    def test_terraform_examples_workflow_valid_yaml(self, workflows_dir):
        """Test that terraform-examples.yml is valid YAML"""
        workflow_file = workflows_dir / "terraform-examples.yml"
        with open(workflow_file, 'r', encoding='utf-8') as f:
            content = f.read()
            yaml.safe_load(content)

    def test_terraform_examples_workflow_structure(self, workflows_dir):
        """Test terraform-examples.yml workflow has required structure"""
        workflow_file = workflows_dir / "terraform-examples.yml"
        with open(workflow_file, 'r', encoding='utf-8') as f:
            workflow = yaml.safe_load(f)

        assert "name" in workflow
        assert workflow["name"] == "Terraform Examples Test"
        assert "jobs" in workflow
        assert "terraform-examples" in workflow["jobs"]

    def test_examples_workflow_uses_correct_directory(self, workflows_dir):
        """Test that examples workflow uses correct working directory"""
        workflow_file = workflows_dir / "terraform-examples.yml"
        with open(workflow_file, 'r', encoding='utf-8') as f:
            workflow = yaml.safe_load(f)

        job_config = workflow["jobs"]["terraform-examples"]

        # Check working directory
        assert "defaults" in job_config
        assert "run" in job_config["defaults"]
        assert "working-directory" in job_config["defaults"]["run"]
        assert job_config["defaults"]["run"]["working-directory"] == "${{ env.TF_WORKING_DIR }}"

    def test_workflows_use_ubuntu_runner(self, workflows_dir):
        """Test that all workflows use Ubuntu runners"""
        workflows = ["terraform.yml", "terraform-mock.yml", "terraform-examples.yml"]

        for workflow_file in workflows:
            workflow_path = workflows_dir / workflow_file
            with open(workflow_path, 'r', encoding='utf-8') as f:
                workflow = yaml.safe_load(f)

            # Find the main job (different names for different workflows)
            jobs = workflow["jobs"]
            main_job = list(jobs.values())[0]

            assert "runs-on" in main_job
            assert "ubuntu" in main_job["runs-on"]

    def test_workflows_use_terraform_setup_action(self, workflows_dir):
        """Test that workflows use hashicorp/setup-terraform action"""
        workflows = ["terraform.yml", "terraform-mock.yml", "terraform-examples.yml"]

        for workflow_file in workflows:
            workflow_path = workflows_dir / workflow_file
            with open(workflow_path, 'r', encoding='utf-8') as f:
                workflow = yaml.safe_load(f)

            jobs = workflow["jobs"]
            main_job = list(jobs.values())[0]
            steps = main_job["steps"]

            # Find terraform setup step
            terraform_step = None
            for step in steps:
                if "uses" in step and "hashicorp/setup-terraform" in step["uses"]:
                    terraform_step = step
                    break

            assert terraform_step is not None, f"{workflow_file} should use hashicorp/setup-terraform action"
