provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "BARQ-AWS-K8S"
      Environment = "dev"
      ManagedBy   = "Terraform"
    }
  }
}
