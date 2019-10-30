/**
* Creates a logging s3 bucket in the secondary region of gov.uk so that the
* logs of that region can be stored in
*
*/

variable "aws_secondary_region" {
  type        = "string"
  description = "Secondary AWS region"
  default     = "eu-west-2"
}

# Resources
# --------------------------------------------------------------

provider "aws" {
  alias   = "aws_secondary"
  region  = "${var.aws_secondary_region}"
  version = "2.33.0"
}

data "template_file" "s3_aws_secondary_logging_policy_template" {
  template = "${file("${path.module}/../../policies/s3_aws_secondary_logging_write_policy.tpl")}"

  vars {
    aws_environment = "${var.aws_environment}"
    aws_account_id  = "${data.aws_elb_service_account.main.arn}"
  }
}

# Create a bucket that allows AWS services to write to it
resource "aws_s3_bucket" "aws-secondary-logging" {
  bucket   = "govuk-${var.aws_environment}-aws-secondary-logging"
  acl      = "log-delivery-write"
  provider = "aws.aws_secondary"

  tags {
    Name        = "govuk-${var.aws_environment}-aws-secondary-logging"
    Environment = "${var.aws_environment}"
  }

  # Expire everything after 30 days
  lifecycle_rule {
    enabled = true

    expiration {
      days = 30
    }
  }

  policy = "${data.template_file.s3_aws_secondary_logging_policy_template.rendered}"
}

# Outputs
# --------------------------------------------------------------

output "aws_secondary_logging_bucket_id" {
  value       = "${aws_s3_bucket.aws-secondary-logging.id}"
  description = "Name of the AWS logging bucket"
}
