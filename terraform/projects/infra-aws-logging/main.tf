/**
* ## Module: projects/infra-aws-logging
*
* Create resources to manage infrastructure logging:
*   - Create an S3 bucket which allows AWS infrastructure to send logs to, for
*     instance, ELB logs
*   - Create resources to export CloudWatch log groups to S3 via Lambda-Kinesis_Firehose
*/

variable "aws_region" {
  type        = "string"
  description = "AWS region"
  default     = "eu-west-1"
}

variable "aws_environment" {
  type        = "string"
  description = "AWS Environment"
}

variable "stackname" {
  type        = "string"
  description = "Stackname"
  default     = ""
}

# Resources
# --------------------------------------------------------------
terraform {
  backend          "s3"             {}
  required_version = "= 0.10.8"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "1.0.0"
}

data "aws_elb_service_account" "main" {}

data "aws_caller_identity" "current" {}

data "template_file" "s3_aws_logging_policy_template" {
  template = "${file("${path.module}/../../policies/s3_aws_logging_write_policy.tpl")}"

  vars {
    aws_environment = "${var.aws_environment}"
    aws_account_id  = "${data.aws_elb_service_account.main.arn}"
  }
}

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

  policy = "${data.template_file.s3_aws_logging_policy_template.rendered}"
}

data "template_file" "iam_aws_logging_logit_read_policy_template" {
  template = "${file("${path.module}/../../policies/iam_s3_aws_logging_read_policy.tpl")}"

  vars {
    aws_environment = "${var.aws_environment}"
  }
}

# Create a read user to allow ingestion of logs from the bucket
resource "aws_iam_policy" "aws-logging_logit-read_iam_policy" {
  name        = "${var.aws_environment}-aws-logging_logit-read_iam_policy"
  path        = "/"
  description = "Allow read access to S3 aws-logging bucket"
  policy      = "${data.template_file.iam_aws_logging_logit_read_policy_template.rendered}"
}

resource "aws_iam_user" "aws-logging_logit-read_iam_user" {
  name = "aws-logging_logit-read"
}

resource "aws_iam_policy_attachment" "aws-logging_logit-read_iam_policy_attachment" {
  name       = "aws-logging_logit-read_iam_policy_attachment"
  users      = ["${aws_iam_user.aws-logging_logit-read_iam_user.name}"]
  policy_arn = "${aws_iam_policy.aws-logging_logit-read_iam_policy.arn}"
}

#
# Export CloudWatch logs to S3 via Lambda - Kinesis Firehose
#

# Kinesis Firehose role configuration
data "template_file" "firehose_assume_policy_template" {
  template = "${file("${path.module}/../../policies/firehose_assume_policy.tpl")}"

  vars {
    aws_account_id = "${data.aws_caller_identity.current.account_id}"
  }
}

resource "aws_iam_role" "firehose_logs_role" {
  name               = "${var.stackname}-firehose-logs"
  path               = "/"
  assume_role_policy = "${data.template_file.firehose_assume_policy_template.rendered}"
}

data "template_file" "firehose_logs_policy_template" {
  template = "${file("${path.module}/../../policies/firehose_logs_policy.tpl")}"

  vars {
    bucket_name = "${aws_s3_bucket.aws-logging.id}"
  }
}

resource "aws_iam_policy" "firehose_logs_policy" {
  name   = "${var.stackname}-firehose-logs-policy"
  path   = "/"
  policy = "${data.template_file.firehose_logs_policy_template.rendered}"
}

resource "aws_iam_role_policy_attachment" "firehose_logs_policy_attachment" {
  role       = "${aws_iam_role.firehose_logs_role.name}"
  policy_arn = "${aws_iam_policy.firehose_logs_policy.arn}"
}

# Lambda role configuration
resource "aws_iam_role" "lambda_logs_to_firehose_role" {
  name               = "${var.stackname}-lambda-logs-to-firehose"
  path               = "/"
  assume_role_policy = "${file("${path.module}/../../policies/lambda_assume_policy.json")}"
}

data "template_file" "lambda_logs_to_firehose_policy_template" {
  template = "${file("${path.module}/../../policies/lambda_logs_to_firehose_policy.tpl")}"

  vars {
    aws_region     = "${var.aws_region}"
    aws_account_id = "${data.aws_caller_identity.current.account_id}"
  }
}

resource "aws_iam_policy" "lambda_logs_to_firehose_policy" {
  name   = "${var.stackname}-lambda-logs-to-firehose"
  path   = "/"
  policy = "${data.template_file.lambda_logs_to_firehose_policy_template.rendered}"
}

resource "aws_iam_role_policy_attachment" "lambda_logs_to_firehose_policy_attachment" {
  role       = "${aws_iam_role.lambda_logs_to_firehose_role.name}"
  policy_arn = "${aws_iam_policy.lambda_logs_to_firehose_policy.arn}"
}

# Lambda RDS logs to S3 role
resource "aws_iam_role" "lambda_rds_logs_to_s3_role" {
  name               = "${var.stackname}-rds-logs-to-s3"
  path               = "/"
  assume_role_policy = "${file("${path.module}/../../policies/lambda_assume_policy.json")}"
}

data "template_file" "lambda_rds_logs_to_s3_policy_template" {
  template = "${file("${path.module}/../../policies/lambda_rds_logs_to_s3_policy.tpl")}"

  vars {
    bucket_name = "${aws_s3_bucket.aws-logging.id}"
  }
}

resource "aws_iam_policy" "lambda_rds_logs_to_s3_policy" {
  name   = "${var.stackname}-rds-logs-to-s3-policy"
  path   = "/"
  policy = "${data.template_file.lambda_rds_logs_to_s3_policy_template.rendered}"
}

resource "aws_iam_role_policy_attachment" "lambda_rds_logs_to_s3_policy_attachment" {
  role       = "${aws_iam_role.lambda_rds_logs_to_s3_role.name}"
  policy_arn = "${aws_iam_policy.lambda_rds_logs_to_s3_policy.arn}"
}

# Outputs
# --------------------------------------------------------------

output "aws_logging_bucket_id" {
  value       = "${aws_s3_bucket.aws-logging.id}"
  description = "Name of the AWS logging bucket"
}

output "aws_logging_bucket_arn" {
  value       = "${aws_s3_bucket.aws-logging.arn}"
  description = "ARN of the AWS logging bucket"
}

output "firehose_logs_role_arn" {
  value       = "${aws_iam_role.firehose_logs_role.arn}"
  description = "ARN of the Kinesis Firehose stream AWS credentials"
}

output "lambda_logs_role_arn" {
  value       = "${aws_iam_role.lambda_logs_to_firehose_role.arn}"
  description = "ARN of the IAM role attached to the Lambda logs Function"
}

output "lambda_rds_logs_to_s3_role_arn" {
  value       = "${aws_iam_role.lambda_rds_logs_to_s3_role.arn}"
  description = "ARN of the IAM role attached to the Lambda RDS logs to S3 Function"
}
