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
