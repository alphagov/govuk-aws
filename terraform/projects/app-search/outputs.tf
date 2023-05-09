output "scale_learntorank_asg_policy_arn" {
  value       = aws_iam_policy.scale-learntorank-generation-asg-policy.arn
  description = "ARN of the policy used by to scale the ASG for learn to rank"
}

output "ltr_role_arn" {
  value       = aws_iam_role.learntorank.arn
  description = "LTR role ARN"
}

output "ecr_repository_url" {
  value       = aws_ecr_repository.repo.repository_url
  description = "URL of the ECR repository"
}

output "search_relevancy_s3_policy_arn" {
  value       = aws_iam_policy.search_relevancy_bucket_access.arn
  description = "ARN of the policy used to access the search-relevancy S3 bucket"
}

output "sitemaps_s3_policy_arn" {
  value       = aws_iam_policy.sitemaps_bucket_access.arn
  description = "ARN of the policy used to access the sitemaps S3 bucket"
}
