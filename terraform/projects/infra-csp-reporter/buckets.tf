# Bucket to store data from Kinesis Firehose, stores both successes and errors
resource "aws_s3_bucket" "csp_reports" {
  bucket = "govuk-${var.aws_environment}-csp-reports"

  tags = {
    Name            = "govuk-${var.aws_environment}-csp-reports"
    aws_environment = var.aws_environment
    project         = local.project_name
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "csp_reports_lifecycle" {
  bucket = aws_s3_bucket.csp_reports.id

  rule {
    id     = "govuk-${var.aws_environment}-csp-reports-lifecycle"
    status = "Enabled"

    expiration {
      days = 30
    }
  }
}
