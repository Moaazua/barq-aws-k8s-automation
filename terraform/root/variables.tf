variable "aws_region" {
  description = "AWS Region for BARQ infrastructure"
  type        = string
  default     = "eu-central-1"
}
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
}

variable "public_az" {
  description = "Availability Zone for the public subnet"
  type        = string
}

variable "private_db_subnet_1_cidr" {
  description = "CIDR block for private DB subnet 1"
  type        = string
}

variable "private_db_subnet_2_cidr" {
  description = "CIDR block for private DB subnet 2"
  type        = string
}

variable "private_db_az_1" {
  description = "Availability Zone for private DB subnet 1"
  type        = string
}

variable "private_db_az_2" {
  description = "Availability Zone for private DB subnet 2"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "Approved public IP CIDR for SSH access"
  type        = string
}

variable "control_plane_instance_type" {
  type = string
}

variable "worker_instance_type" {
  type = string
}

variable "key_name" {
  description = "Existing EC2 Key Pair name"
  type        = string
}

variable "db_instance_class" {
  description = "RDS PostgreSQL instance class"
  type        = string
}

variable "db_password" {
  description = "PostgreSQL master password"
  type        = string
  sensitive   = true
}

variable "elasticache_auth_token" {
  description = "ElastiCache Redis AUTH token"
  type        = string
  sensitive   = true
}

