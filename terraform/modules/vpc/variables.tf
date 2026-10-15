# VPC
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

# Public Subnet
variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
}

variable "public_az" {
  description = "Availability Zone for the public subnet"
  type        = string
}

# Private DB Subnets
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