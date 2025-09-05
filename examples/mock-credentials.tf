# Mock AWS credentials for local testing and terraform plan dry run

provider "aws" {
  alias                       = "mock"
  region                      = "us-east-1"
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}
