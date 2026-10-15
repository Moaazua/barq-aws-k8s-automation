######################################
##### VPC-Module ########################
######################################
module "vpc" {
  source = "../modules/vpc"

  vpc_cidr                 = var.vpc_cidr
  public_subnet_cidr       = var.public_subnet_cidr
  public_az                = var.public_az
  private_db_subnet_1_cidr = var.private_db_subnet_1_cidr
  private_db_subnet_2_cidr = var.private_db_subnet_2_cidr
  private_db_az_1          = var.private_db_az_1
  private_db_az_2          = var.private_db_az_2
}

######################################
##### security-Module ########################
######################################
# Security Groups Module
module "security_groups" {
  source = "../modules/security-groups"

  vpc_id           = module.vpc.vpc_id
  allowed_ssh_cidr = var.allowed_ssh_cidr
}

######################################
##### IAM-Module ########################
######################################
# IAM Module
module "iam" {
  source = "../modules/iam"
}
