# Configure the AWS Provider
provider "aws" {
  version = "~> 2.0"
  region = "eu-central-1"
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}