# Trust Policy - Allow EC2 to assume IAM Role
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Control Plane IAM Role
resource "aws_iam_role" "control_plane" {
  name               = "barq-control-plane-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = {
    Name = "barq-control-plane-role"
  }
}

# Worker IAM Role
resource "aws_iam_role" "worker" {
  name               = "barq-worker-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = {
    Name = "barq-worker-role"
  }
}

# Attach SSM Policy to Control Plane Role
resource "aws_iam_role_policy_attachment" "control_plane_ssm" {
  role       = aws_iam_role.control_plane.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Attach SSM Policy to Worker Role
resource "aws_iam_role_policy_attachment" "worker_ssm" {
  role       = aws_iam_role.worker.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Control Plane Instance Profile
resource "aws_iam_instance_profile" "control_plane" {
  name = "barq-control-plane-profile"
  role = aws_iam_role.control_plane.name

  tags = {
    Name = "barq-control-plane-profile"
  }
}

# Worker Instance Profile
resource "aws_iam_instance_profile" "worker" {
  name = "barq-worker-profile"
  role = aws_iam_role.worker.name

  tags = {
    Name = "barq-worker-profile"
  }
}
