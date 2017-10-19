# == Manifest: projects::infra-aws-logging
#
# Create an S3 bucket which allows AWS infrastructure to send logs, which then
#
# === Variables:
#
# aws_region
# aws_environment
#
# === Outputs:
#
# aws_logging_bucket_id
#
variable "aws_region" {
  type        = "string"
  description = "AWS region"
  default     = "eu-west-1"
}

variable "aws_environment" {
  type        = "string"
  description = "AWS Environment"
}

# Resources
# --------------------------------------------------------------
terraform {
  backend          "s3"             {}
  required_version = "= 0.10.7"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "1.0.0"
}

data "aws_elb_service_account" "main" {}

# Create a bucket that allows AWS services to write to it
resource "aws_s3_bucket" "aws-logging" {
  bucket = "govuk-${var.aws_environment}-aws-logging"
  acl    = "private"

  tags {
    Name        = "govuk-${var.aws_environment}-aws-logging"
    Environment = "${var.aws_environment}"
  }

  # Expire everything after 30 days
  lifecycle_rule {
    enabled = true

    prefix = "/"

    expiration {
      days = 30
    }
  }

  policy = <<POLICY
{
  "Id": "Policy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::govuk-${var.aws_environment}-aws-logging/*",
      "Principal": {
        "AWS": [
          "${data.aws_elb_service_account.main.arn}"
        ]
      }
    }
  ]
}
POLICY
}

# Create a read user to allow ingestion of logs from the bucket
resource "aws_iam_policy" "aws-logging_logit-read_iam_policy" {
  name        = "${var.aws_environment}-aws-logging_logit-read_iam_policy"
  path        = "/"
  description = "Allow "

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "SidID",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:ListBucket"
             ],
            "Resource": [
                "arn:aws:s3:::govuk-${var.aws_environment}-aws-logging/*"
            ]
        }
    ]
 }
EOF
}

resource "aws_iam_user" "aws-logging_logit-read_iam_user" {
  name = "aws-logging_logit-read"
}

resource "aws_iam_policy_attachment" "aws-logging_logit-read_iam_policy_attachment" {
  name       = "aws-logging_logit-read_iam_policy_attachment"
  users      = ["${aws_iam_user.aws-logging_logit-read_iam_user.name}"]
  policy_arn = "${aws_iam_policy.aws-logging_logit-read_iam_policy.arn}"
}

# Outputs
# --------------------------------------------------------------

output "aws_logging_bucket_id" {
  value       = "${aws_s3_bucket.aws-logging.id}"
  description = "Name of the AWS logging bucket"
}
