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

output "rds_endpoint" {
  value = module.rds.rds_endpoint
}

output "rds_address" {
  value = module.rds.rds_address
}

output "rds_port" {
  value = module.rds.rds_port
}

output "rds_db_name" {
  value = module.rds.rds_db_name
}

output "control_plane_public_ip" {
  value = module.ec2.control_plane_public_ip
}

output "control_plane_private_ip" {
  value = module.ec2.control_plane_private_ip
}

output "worker_public_ip" {
  value = module.ec2.worker_public_ip
}

output "worker_private_ip" {
  value = module.ec2.worker_private_ip
}
