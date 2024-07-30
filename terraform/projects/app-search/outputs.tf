output "sitemaps_s3_policy_arn" {
  value       = aws_iam_policy.sitemaps_bucket_access.arn
  description = "ARN of the policy used to access the sitemaps S3 bucket"
}
