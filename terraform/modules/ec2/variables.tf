# EC2 Instance Types
variable "control_plane_instance_type" {
  description = "Instance type for Kubernetes Control Plane"
  type        = string
}

variable "worker_instance_type" {
  description = "Instance type for Kubernetes Worker"
  type        = string
}

# Networking
variable "public_subnet_id" {
  description = "Public subnet ID for EC2 instances"
  type        = string
}

variable "control_plane_sg_id" {
  description = "Security Group ID for Control Plane"
  type        = string
}

variable "worker_sg_id" {
  description = "Security Group ID for Worker"
  type        = string
}

# SSH
variable "key_name" {
  description = "Existing AWS EC2 Key Pair name"
  type        = string
}

# IAM Instance Profiles
variable "control_plane_instance_profile_name" {
  description = "IAM Instance Profile for Control Plane"
  type        = string
}

variable "worker_instance_profile_name" {
  description = "IAM Instance Profile for Worker"
  type        = string
}
