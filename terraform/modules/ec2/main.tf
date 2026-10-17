# AMI pinned to prevent unexpected EC2
# replacement when a newer AMI appears.

################################
# Kubernetes Control Plane EC2 #
################################
resource "aws_instance" "control_plane" {
  ami           = "ami-04de259f26cbf4c1e"
  instance_type = var.control_plane_instance_type

  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.control_plane_sg_id]
  associate_public_ip_address = true

  key_name             = var.key_name
  iam_instance_profile = var.control_plane_instance_profile_name

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
    encrypted   = true
  }

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name = "barq-control-plane"
    Role = "control-plane"
  }
}

#########################
# Kubernetes Worker EC2 #
#########################
resource "aws_instance" "worker" {
  ami           = "ami-04de259f26cbf4c1e"
  instance_type = var.worker_instance_type

  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.worker_sg_id]
  associate_public_ip_address = true

  key_name             = var.key_name
  iam_instance_profile = var.worker_instance_profile_name

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
    encrypted   = true
  }

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name = "barq-worker"
    Role = "worker"
  }
}
