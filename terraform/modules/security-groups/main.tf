# Control Plane Security Group
resource "aws_security_group" "control_plane" {
  name        = "barq-control-plane-sg"
  description = "Security group for Kubernetes Control Plane"
  vpc_id      = var.vpc_id

  tags = {
    Name = "barq-control-plane-sg"
  }
}

# Worker Security Group
resource "aws_security_group" "worker" {
  name        = "barq-worker-sg"
  description = "Security group for Kubernetes Worker"
  vpc_id      = var.vpc_id

  tags = {
    Name = "barq-worker-sg"
  }
}

# RDS Security Group
resource "aws_security_group" "rds" {
  name        = "barq-rds-sg"
  description = "Security group for PostgreSQL RDS"
  vpc_id      = var.vpc_id

  tags = {
    Name = "barq-rds-sg"
  }
}

# SSH Access to Control Plane
resource "aws_vpc_security_group_ingress_rule" "control_plane_ssh" {
  security_group_id = aws_security_group.control_plane.id

  cidr_ipv4   = var.allowed_ssh_cidr
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"

  description = "Allow SSH from approved IP"
}

# SSH Access to Worker
resource "aws_vpc_security_group_ingress_rule" "worker_ssh" {
  security_group_id = aws_security_group.worker.id

  cidr_ipv4   = var.allowed_ssh_cidr
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"

  description = "Allow SSH from approved IP"
}

# Worker -> Control Plane: Kubernetes API
resource "aws_vpc_security_group_ingress_rule" "k8s_api" {
  security_group_id            = aws_security_group.control_plane.id
  referenced_security_group_id = aws_security_group.worker.id

  from_port   = 6443
  to_port     = 6443
  ip_protocol = "tcp"

  description = "Allow worker to access Kubernetes API"
}

# Control Plane -> Worker: Kubelet
resource "aws_vpc_security_group_ingress_rule" "worker_kubelet" {
  security_group_id            = aws_security_group.worker.id
  referenced_security_group_id = aws_security_group.control_plane.id

  from_port   = 10250
  to_port     = 10250
  ip_protocol = "tcp"

  description = "Allow control plane to access worker kubelet"
}

# Worker -> Control Plane: Flannel VXLAN
resource "aws_vpc_security_group_ingress_rule" "flannel_control_plane" {
  security_group_id            = aws_security_group.control_plane.id
  referenced_security_group_id = aws_security_group.worker.id

  from_port   = 8472
  to_port     = 8472
  ip_protocol = "udp"

  description = "Allow Flannel VXLAN from worker"
}

# Control Plane -> Worker: Flannel VXLAN
resource "aws_vpc_security_group_ingress_rule" "flannel_worker" {
  security_group_id            = aws_security_group.worker.id
  referenced_security_group_id = aws_security_group.control_plane.id

  from_port   = 8472
  to_port     = 8472
  ip_protocol = "udp"

  description = "Allow Flannel VXLAN from control plane"
}

# Allow PostgreSQL access from Worker Node
resource "aws_vpc_security_group_ingress_rule" "rds_postgres" {
  security_group_id            = aws_security_group.rds.id
  referenced_security_group_id = aws_security_group.worker.id

  from_port   = 5432
  to_port     = 5432
  ip_protocol = "tcp"

  description = "Allow PostgreSQL access from Kubernetes Worker"
}

# Control Plane Outbound Traffic
resource "aws_vpc_security_group_egress_rule" "control_plane_egress" {
  security_group_id = aws_security_group.control_plane.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"

  description = "Allow outbound traffic from Control Plane"
}

# Worker Outbound Traffic
resource "aws_vpc_security_group_egress_rule" "worker_egress" {
  security_group_id = aws_security_group.worker.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"

  description = "Allow outbound traffic from Worker"
}

# Allow access to BARQ application via NodePort
resource "aws_vpc_security_group_ingress_rule" "worker_nodeport" {
  security_group_id = aws_security_group.worker.id

  cidr_ipv4   = var.allowed_ssh_cidr
  from_port   = 30080
  to_port     = 30080
  ip_protocol = "tcp"

  description = "Allow BARQ application access via NodePort"
}
###################################################################
# ElastiCache Security Group
resource "aws_security_group" "elasticache" {
  name        = "barq-elasticache-sg"
  description = "Security group for BARQ ElastiCache Redis"
  vpc_id      = var.vpc_id

  tags = {
    Name = "barq-elasticache-sg"
  }
}

# Allow Redis traffic from Kubernetes Worker only
resource "aws_vpc_security_group_ingress_rule" "elasticache_redis" {
  security_group_id            = aws_security_group.elasticache.id
  referenced_security_group_id = aws_security_group.worker.id

  from_port   = 6379
  to_port     = 6379
  ip_protocol = "tcp"

  description = "Allow Redis traffic from Kubernetes Worker"
}