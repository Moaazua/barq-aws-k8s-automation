terraform {
  backend "s3" {
    bucket       = "barq-terraform-state-20261015-d875fd65"
    key          = "dev/terraform.tfstate"
    region       = "eu-central-1"
    encrypt      = true
    use_lockfile = true
  }
}
