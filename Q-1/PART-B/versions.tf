terraform {
  # Require Terraform 1.3 or higher
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0" # AWS provider version
    }
  }

  # Using local backend (for demo). In production use S3 + DynamoDB for state locking.
  backend "local" {
    path = "terraform.tfstate"
  }
}
