variable "vpc_id" {
  description = "VPC ID for Security Groups"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "Allowed CIDR block for SSH access"
  type        = string
}