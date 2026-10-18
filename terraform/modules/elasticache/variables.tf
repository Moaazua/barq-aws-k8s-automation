variable "private_subnet_ids" {
  description = "Private subnet IDs for ElastiCache"
  type        = list(string)
}

variable "security_group_id" {
  description = "ElastiCache Security Group ID"
  type        = string
}

variable "node_type" {
  description = "ElastiCache node type"
  type        = string
  default     = "cache.t4g.micro"
}

variable "auth_token" {
  description = "Redis authentication token"
  type        = string
  sensitive   = true
}