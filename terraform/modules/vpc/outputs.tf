# VPC ID
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

# Public Subnet ID
output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

# Private DB Subnet IDs
output "private_db_subnet_ids" {
  description = "IDs of the private database subnets"
  value = [
    aws_subnet.private_db_1.id,
    aws_subnet.private_db_2.id
  ]
}

# Internet Gateway ID
output "igw_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}
