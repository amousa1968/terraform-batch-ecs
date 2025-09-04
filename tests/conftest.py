import pytest
import subprocess
import json
import re
from pathlib import Path
from typing import Tuple


@pytest.fixture(scope="session")
def terraform_examples_dir():
    """Fixture to get the examples directory path"""
    return Path(__file__).parent.parent / "examples"


@pytest.fixture(scope="session")
def terraform_init(terraform_examples_dir):
    """Fixture to ensure terraform is initialized"""
    init_result = subprocess.run(
        ["terraform", "init", "-no-color"],
        cwd=terraform_examples_dir,
        capture_output=True,
        text=True
    )
    assert init_result.returncode == 0, f"Terraform init failed: {init_result.stderr}"


@pytest.fixture(scope="function")
def terraform_plan(terraform_examples_dir, terraform_init) -> Tuple[str, str, int]:
    """Fixture to run terraform plan and return output"""
    plan_result = subprocess.run(
        ["terraform", "plan", "-no-color", "-input=false"],
        cwd=terraform_examples_dir,
        capture_output=True,
        text=True
    )
    return plan_result.stdout, plan_result.stderr, plan_result.returncode


@pytest.fixture(scope="function")
def terraform_validate(terraform_examples_dir, terraform_init) -> Tuple[str, str, int]:
    """Fixture to run terraform validate"""
    validate_result = subprocess.run(
        ["terraform", "validate", "-no-color"],
        cwd=terraform_examples_dir,
        capture_output=True,
        text=True
    )
    return validate_result.stdout, validate_result.stderr, validate_result.returncode


@pytest.fixture(scope="function")
def terraform_fmt_check(terraform_examples_dir) -> Tuple[str, str, int]:
    """Fixture to run terraform fmt check"""
    fmt_result = subprocess.run(
        ["terraform", "fmt", "-check", "-no-color"],
        cwd=terraform_examples_dir,
        capture_output=True,
        text=True
    )
    return fmt_result.stdout, fmt_result.stderr, fmt_result.returncode


@pytest.fixture(scope="function")
def parsed_plan_output(terraform_plan):
    """Fixture to parse terraform plan output into structured data"""
    stdout, stderr, returncode = terraform_plan

    if returncode != 0:
        pytest.fail(f"Terraform plan failed: {stderr}")

    # Parse the plan output to extract resource information
    resources = []
    lines = stdout.split('\n')
    current_resource = None

    for line in lines:
        if line.startswith('  # module.batch_ecs.aws_'):
            # Extract resource type and name
            resource_match = re.search(r'aws_([^.]+)\.([^\s]+)', line)
            if resource_match:
                resource_type = resource_match.group(1)
                resource_name = resource_match.group(2)
                current_resource = {
                    'type': resource_type,
                    'name': resource_name,
                    'attributes': []
                }
                resources.append(current_resource)
        elif current_resource and line.strip().startswith('+') and '=' in line:
            # Extract attribute
            attr_line = line.strip()[1:].strip()
            if '=' in attr_line:
                key, value = attr_line.split('=', 1)
                current_resource['attributes'].append({
                    'key': key.strip(),
                    'value': value.strip()
                })

    return {
        'resources': resources,
        'plan_summary': extract_plan_summary(stdout)
    }


def extract_plan_summary(plan_output: str) -> dict:
    """Extract plan summary information"""
    summary = {}

    # Find the plan summary line
    for line in plan_output.split('\n'):
        if 'Plan:' in line and 'to add' in line:
            # Extract numbers using regex
            add_match = re.search(r'(\d+) to add', line)
            change_match = re.search(r'(\d+) to change', line)
            destroy_match = re.search(r'(\d+) to destroy', line)

            summary['add'] = int(add_match.group(1)) if add_match else 0
            summary['change'] = int(change_match.group(1)) if change_match else 0
            summary['destroy'] = int(destroy_match.group(1)) if destroy_match else 0
            break

    return summary


@pytest.fixture(scope="function")
def expected_resources():
    """Fixture with expected resource definitions"""
    return {
        'aws_batch_compute_environment': {
            'name': 'batch_compute_env',
            'attributes': {
                'compute_environment_name': '"example-batch-compute-env"',
                'state': '"ENABLED"',
                'type': '"MANAGED"'
            }
        },
        'aws_batch_job_definition': {
            'name': 'batch_job_definition',
            'attributes': {
                'name': '"example-batch-job-def"',
                'type': '"container"'
            }
        },
        'aws_batch_job_queue': {
            'name': 'batch_job_queue',
            'attributes': {
                'name': '"example-batch-job-queue"',
                'state': '"ENABLED"',
                'priority': '1'
            }
        },
        'aws_ecs_cluster': {
            'name': 'ecs-batch',
            'attributes': {
                'name': '"example-fargate-cluster"'
            }
        },
        'aws_ecs_service': {
            'name': 'ecs-batch',
            'attributes': {
                'name': '"fargate-service"',
                'desired_count': '1',
                'launch_type': '"FARGATE"'
            }
        },
        'aws_cloudwatch_log_group': {
            'name': 'ecs-batch',
            'attributes': {
                'name': '"/ecs/fargate"',
                'retention_in_days': '14'
            }
        }
    }
