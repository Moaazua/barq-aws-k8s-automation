output "control_plane_instance_profile_name" {
  description = "Control Plane EC2 Instance Profile Name"
  value       = aws_iam_instance_profile.control_plane.name
}

output "worker_instance_profile_name" {
  description = "Worker EC2 Instance Profile Name"
  value       = aws_iam_instance_profile.worker.name
}
