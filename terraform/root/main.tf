######################################
##### VPC-Module #####################
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
##### security-Module ################
######################################
# Security Groups Module
module "security_groups" {
  source = "../modules/security-groups"

  vpc_id           = module.vpc.vpc_id
  allowed_ssh_cidr = var.allowed_ssh_cidr
}

######################################
##### IAM-Module #####################
######################################
# IAM Module
module "iam" {
  source = "../modules/iam"
}
##############################
# EC2 Module #################
##############################
module "ec2" {
  source = "../modules/ec2"

  control_plane_instance_type = var.control_plane_instance_type
  worker_instance_type        = var.worker_instance_type

  public_subnet_id    = module.vpc.public_subnet_id
  control_plane_sg_id = module.security_groups.control_plane_sg_id
  worker_sg_id        = module.security_groups.worker_sg_id

  key_name = var.key_name

  control_plane_instance_profile_name = module.iam.control_plane_instance_profile_name
  worker_instance_profile_name        = module.iam.worker_instance_profile_name
}
#########################
# RDS PostgreSQL Module #
#########################
module "rds" {
  source = "../modules/rds"

  private_db_subnet_ids = module.vpc.private_db_subnet_ids
  rds_sg_id             = module.security_groups.rds_sg_id

  db_instance_class = var.db_instance_class
  db_password       = var.db_password
}
