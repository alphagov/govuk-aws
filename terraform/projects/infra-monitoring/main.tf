/**
* ## Module: projects/infra-monitoring
*
* Create resources to manage infrastructure and app monitoring:
*   - Create an S3 bucket which allows AWS infrastructure to send logs to, for
*     instance, ELB logs
*   - Create resources to export CloudWatch log groups to S3 via Lambda-Kinesis_Firehose
*   - Create SNS topic to send infrastructure alerts, and a SQS queue that subscribes to
*     the topic
*   - Create an IAM user which allows Terraboard to read Terraform state files from S3
*   - Create an IAM user and role which allows the X-Ray daemon to upload trace
*     data to X-Ray (only required while trace data is sent from Carrenza)
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

variable "cyber_slunk_s3_bucket_name" {
  type        = "string"
  description = "Name of the Cyber S3 bucket where aws logging will be replicated"
  default     = "na"
}

variable "cyber_slunk_aws_account_id" {
  type        = "string"
  description = "AWS account ID of the Cyber S3 bucket where aws logging will be replicated"
  default     = "na"
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
  required_version = "= 0.11.14"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "2.33.0"
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

data "template_file" "s3_govuk_aws_logging_replication_policy_template" {
  template = "${file("${path.module}/../../policies/s3_govuk_aws_logging_replication_policy.tpl")}"

  vars {
    govuk_aws_logging_arn  = "${aws_s3_bucket.aws-logging.arn}"
    govuk_cyber_splunk_arn = "arn:aws:s3:::${var.cyber_slunk_s3_bucket_name}"
  }
}

data "template_file" "s3_govuk_aws_logging_replication_role_template" {
  template = "${file("${path.module}/../../policies/s3_govuk_aws_logging_replication_role.tpl")}"
}

resource "aws_iam_policy" "govuk_aws_logging_replication_policy" {
  #count       = "${var.aws_environment == "production"? 1 : 0}"
  name        = "govuk-${var.aws_environment}-aws-logging-bucket-replication-policy"
  policy      = "${data.template_file.s3_govuk_aws_logging_replication_policy_template.rendered}"
  description = "Allows replication of the aws-logging bucket"
}

resource "aws_iam_role" "govuk_aws_logging_replication_role" {
  #count              = "${var.aws_environment == "production"? 1 : 0}"
  name               = "${var.stackname}-aws-logging-replication-role"
  assume_role_policy = "${data.template_file.s3_govuk_aws_logging_replication_role_template.rendered}"
}

resource "aws_iam_policy_attachment" "govuk_aws_logging_replication_policy_attachment" {
  #count      = "${var.aws_environment == "production"? 1 : 0}"
  name       = "s3-govuk-aws-logging-replication-policy-attachment"
  roles      = ["${aws_iam_role.govuk_aws_logging_replication_role.name}"]
  policy_arn = "${aws_iam_policy.govuk_aws_logging_replication_policy.arn}"
}

# Create a bucket that allows AWS services to write to it
resource "aws_s3_bucket" "aws-logging" {
  bucket = "govuk-${var.aws_environment}-aws-logging"
  acl    = "log-delivery-write"

  tags {
    Name        = "govuk-${var.aws_environment}-aws-logging"
    Environment = "${var.aws_environment}"
  }

  # Expire everything after 30 days
  lifecycle_rule {
    enabled = true

    expiration {
      days = 30
    }
  }

  versioning {
    enabled = true
  }

  replication_configuration {
    role = "${aws_iam_role.govuk_aws_logging_replication_role.arn}"

    rules {
      id     = "govuk-aws-logging-elb-govuk-public-ckan-rule"
      prefix = "elb/govuk-ckan-public-elb"
      status = "${var.aws_environment == "production"? "Enabled" : "Disabled"}"

      destination {
        bucket        = "arn:aws:s3:::${var.cyber_slunk_s3_bucket_name}"
        storage_class = "STANDARD"
        account_id    = "${var.cyber_slunk_aws_account_id}"

        access_control_translation {
          owner = "Destination"
        }
      }
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

#
# Create SNS topic with SQS queue subscription to send CloudWatch alerts and infrastructure
# notifications
#

resource "aws_sns_topic" "notifications" {
  name = "${var.stackname}-notifications"
}

resource "aws_sqs_queue" "notifications" {
  name = "${var.stackname}-notifications"
}

resource "aws_sns_topic_subscription" "notifications_sqs_target" {
  topic_arn = "${aws_sns_topic.notifications.arn}"
  protocol  = "sqs"
  endpoint  = "${aws_sqs_queue.notifications.arn}"
}

data "template_file" "notifications_sqs_queue_policy_template" {
  template = "${file("${path.module}/../../policies/sqs_allow_sns_policy.tpl")}"

  vars {
    sns_topic_arn = "${aws_sns_topic.notifications.arn}"
    sqs_queue_arn = "${aws_sqs_queue.notifications.arn}"
  }
}

resource "aws_sqs_queue_policy" "notifications_sqs_queue_policy" {
  queue_url = "${aws_sqs_queue.notifications.id}"
  policy    = "${data.template_file.notifications_sqs_queue_policy_template.rendered}"
}

#
# Create an IAM user which allows Terraboard to read Terraform state files from S3
#

data "template_file" "terraboard_policy_template" {
  template = "${file("${path.module}/../../policies/terraboard_policy.tpl")}"

  vars {
    aws_environment = "${var.aws_environment}"
  }
}

resource "aws_iam_policy" "terraboard_policy" {
  name        = "${var.aws_environment}-terraboard-policy"
  path        = "/"
  description = "Allow read access to S3 govuk-terraform-steppingstone bucket for the environment"
  policy      = "${data.template_file.terraboard_policy_template.rendered}"
}

resource "aws_iam_user" "terraboard_user" {
  name = "govuk-terraboard"
}

resource "aws_iam_policy_attachment" "terraboard_user_policy_attachment" {
  name       = "terraboard_user_policy_attachment"
  users      = ["${aws_iam_user.terraboard_user.name}"]
  policy_arn = "${aws_iam_policy.terraboard_policy.arn}"
}

#
# Create an IAM user and role which allows the AWS X-Ray daemon to upload trace
# data to AWS X-Ray (only required while trace data is sent from Carrenza)
#

resource "aws_iam_user" "xray_daemon_user" {
  name = "govuk-xray-daemon"
}

data "template_file" "xray_daemon_policy_template" {
  template = "${file("${path.module}/../../policies/xray_traces_assume_policy.tpl")}"

  vars {
    xray_daemon_user_arn = "${aws_iam_user.xray_daemon_user.arn}"
  }
}

resource "aws_iam_policy" "xray_daemon_policy" {
  name   = "${var.stackname}-xray-daemon-traces-policy"
  path   = "/"
  policy = "${file("${path.module}/../../policies/xray_traces_policy.json")}"
}

resource "aws_iam_role" "xray_daemon_role" {
  name               = "${var.stackname}-xray-daemon-traces"
  assume_role_policy = "${data.template_file.xray_daemon_policy_template.rendered}"
}

resource "aws_iam_role_policy_attachment" "xray_daemon_role_policy_attachment" {
  role       = "${aws_iam_role.xray_daemon_role.name}"
  policy_arn = "${aws_iam_policy.xray_daemon_policy.arn}"
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

output "sns_topic_cloudwatch_alarms_arn" {
  value       = "${aws_sns_topic.notifications.arn}"
  description = "ARN of the SNS topic for CloudWatch alarms"
}

output "sns_topic_autoscaling_group_events_arn" {
  value       = "${aws_sns_topic.notifications.arn}"
  description = "ARN of the SNS topic for ASG events"
}

output "sns_topic_rds_events_arn" {
  value       = "${aws_sns_topic.notifications.arn}"
  description = "ARN of the SNS topic for RDS events"
}

output "xray_daemon_role_arn" {
  value       = "${aws_iam_role.xray_daemon_role.arn}"
  description = "ARN of the IAM role with permissions to upload traces to X-Ray"
}
