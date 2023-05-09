output "efs_mount_target_dns_names" {
  value       = aws_efs_mount_target.assets-mount-target.0.dns_name
  description = "DNS name for assets NFS mount target"
}
