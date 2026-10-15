output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = module.vpc.public_subnet_id
}

output "private_db_subnet_ids" {
  description = "IDs of the private DB subnets"
  value       = module.vpc.private_db_subnet_ids
}

output "igw_id" {
  description = "ID of the Internet Gateway"
  value       = module.vpc.igw_id
}

output "control_plane_instance_profile_name" {
  description = "Control Plane Instance Profile Name"
  value       = module.iam.control_plane_instance_profile_name
}

output "worker_instance_profile_name" {
  description = "Worker Instance Profile Name"
  value       = module.iam.worker_instance_profile_name
}