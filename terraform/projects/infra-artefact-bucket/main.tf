/**
*  ## Project: artefact-bucket
*
* This creates 3 S3 buckets:
*
* artefact: The bucket that will hold the artefacts
* artefact_access_logs: Bucket for logs to go to
* artefact_replication_destination: Bucket in another region to replicate to
*
* It creates two IAM roles:
* artefact_writer: used by CI to write new artefacts, and deploy instances
* to write to "deployed-to-environment" branches
*
* artefact_reader: used by instances to fetch artefacts
*
* This module creates the following.
*      - AWS SNS topic
*      - AWS S3 Bucket event
*      - AWS S3 Bucket policy.
*      - AWS Lambda function.
*      - AWS SNS subscription
*      - AWS IAM roles and polisis for SNS and Lambda.
*
*/
variable "aws_region" {
  type        = "string"
  description = "AWS region"
  default     = "eu-west-1"
}

variable "aws_secondary_region" {
  type        = "string"
  description = "Secondary region for cross-replication"
  default     = "eu-west-2"
}

variable "aws_environment" {
  type        = "string"
  description = "AWS Environment"
}

variable "aws_subscription_account_id" {
  type        = "string"
  description = "The AWS Account ID that will appear on the subscription"
}

variable "create_sns_topic" {
  type        = "string"
  default     = false
  description = "Indicates whether to create an SNS Topic"
}

variable "create_sns_subscription" {
  type        = "string"
  default     = false
  description = "Indicates whether to create an SNS subscription"
}

variable "aws_subscription_account_region" {
  type        = "string"
  default     = "eu-west-1"
  description = "AWS region of the SNS topic"
}

variable "artefact_source" {
  type        = "string"
  description = "Identifies the source artefact environment"
}

variable "aws_s3_access_account" {
  type        = "list"
  description = "Here we define the account that will have access to the Artefact S3 bucket."
}

variable "stackname" {
  type        = "string"
  description = "Stackname"
}

variable "remote_state_bucket" {
  type        = "string"
  description = "S3 bucket we store our terraform state in"
}

variable "remote_state_infra_monitoring_key_stack" {
  type        = "string"
  description = "Override stackname path to infra_monitoring remote state "
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

provider "aws" {
  alias   = "secondary"
  region  = "${var.aws_secondary_region}"
  version = "2.33.0"
}

provider "aws" {
  alias   = "subscription"
  region  = "${var.aws_subscription_account_region}"
  version = "2.33.0"
}

data "aws_caller_identity" "current" {}

data "terraform_remote_state" "infra_monitoring" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket}"
    key    = "${coalesce(var.remote_state_infra_monitoring_key_stack, var.stackname)}/infra-monitoring.tfstate"
    region = "${var.aws_region}"
  }
}

# Replication bucket (different region to the other buckets)
resource "aws_s3_bucket" "artefact_replication_destination" {
  provider = "aws.secondary"
  bucket   = "govuk-${var.aws_environment}-artefact-replication-destination"

  versioning {
    enabled = true
  }
}

# Main bucket
resource "aws_s3_bucket" "artefact" {
  bucket = "govuk-${var.aws_environment}-artefact"
  acl    = "private"

  tags {
    Name            = "govuk-${var.aws_environment}-artefact"
    aws_environment = "${var.aws_environment}"
  }

  versioning {
    enabled = true
  }

  logging {
    target_bucket = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    target_prefix = "s3/govuk-${var.aws_environment}-artefact/"
  }

  replication_configuration {
    role = "${aws_iam_role.artefact_replication.arn}"

    rules {
      id     = "govuk-artefact-replication-whole-bucket-rule"
      status = "Enabled"
      prefix = ""

      destination {
        bucket = "${aws_s3_bucket.artefact_replication_destination.arn}"
      }
    }
  }
}

# AWS S3 Bucket policy for Lambda access

/**
*
* Note:
*
* When we created this bucket policy (March 2018), Terraform didn't have a method
* to describe a bucket policy as a 'policy statement' or 'template file'. Due to
* this reason, we have used an 'in-line' approach.
* (https://www.terraform.io/docs/providers/aws/r/s3_bucket_policy.html).
*
* We have also defined 'ARN's within the code due to the inability to
* interpolate a list within the in-line format.
*
* We prefer to replace this resource format when the necessary feature or new
* methods are available
*/

data "aws_iam_policy_document" "govuk-artefact-bucket" {
  statement {
    sid = "Stmt1519740678001"

    actions = [
      "s3:*",
    ]

    resources = ["arn:aws:s3:::govuk-${var.aws_environment}-artefact/*"]

    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
        "${var.aws_s3_access_account}",
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "govuk-artefact-bucket-policy" {
  bucket = "${aws_s3_bucket.artefact.id}"
  policy = "${data.aws_iam_policy_document.govuk-artefact-bucket.json}"
}

# Create an AWS SNS Topic
resource "aws_sns_topic" "artefact_topic" {
  count = "${var.create_sns_topic ? 1 : 0}"
  name  = "govuk-${var.aws_environment}-artefact"
}

# AWS SNS Topic Policy
resource "aws_sns_topic_policy" "artefact_topic_policy" {
  count  = "${var.create_sns_topic ? 1 : 0}"
  arn    = "${aws_sns_topic.artefact_topic.arn}"
  policy = "${data.aws_iam_policy_document.artefact_sns_topic_policy.json}"
}

# AWS SNS Topic Policy Data
data "aws_iam_policy_document" "artefact_sns_topic_policy" {
  count     = "${var.create_sns_topic ? 1 : 0}"
  policy_id = "__default_policy_ID"

  statement {
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      "${aws_sns_topic.artefact_topic.arn}",
    ]

    sid = "__default_statement_ID"
  }
}

# AWS S3 Bucket Event
resource "aws_s3_bucket_notification" "artefact_bucket_notification" {
  count      = "${var.create_sns_topic ? 1 : 0}"
  bucket     = "${aws_s3_bucket.artefact.id}"
  depends_on = ["aws_sns_topic.artefact_topic"]

  topic {
    topic_arn = "${aws_sns_topic.artefact_topic.arn}"
    events    = ["s3:ObjectCreated:*"]
  }
}

# AWS SNS Subscription
resource "aws_sns_topic_subscription" "artefact_topic_subscription" {
  count     = "${var.create_sns_subscription ? 1 : 0}"
  provider  = "aws.subscription"
  topic_arn = "arn:aws:sns:${var.aws_subscription_account_region}:${var.aws_subscription_account_id}:govuk-${var.artefact_source}-artefact"
  protocol  = "lambda"
  endpoint  = "arn:aws:lambda:${var.aws_region}:${data.aws_caller_identity.current.account_id}:function:govuk-${var.aws_environment}-artefact"
}

# AWS Lambda
resource "aws_lambda_function" "artefact_lambda_function" {
  count         = "${var.create_sns_subscription ? 1 : 0}"
  filename      = "../../lambda/ArtefactSync/ArtefactSync.zip"
  function_name = "govuk-${var.aws_environment}-artefact"
  role          = "${aws_iam_role.govuk_artefact_lambda_role.arn}"
  handler       = "main.lambda_handler"
  runtime       = "python2.7"
}

# AWS Lambda Role
resource "aws_iam_role" "govuk_artefact_lambda_role" {
  count = "${var.create_sns_subscription ? 1 : 0}"
  name  = "govuk_artefact_lambda_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# AWS SNS IAM Policy - Template file
data "template_file" "govuk_artefact_policy_template" {
  template = "${file("${path.module}/../../policies/govuk_artefact_policy.tpl")}"

  vars {
    artefact_source = "${var.artefact_source}"
    aws_environment = "${var.aws_environment}"
  }
}

# AWS SNS IAM Policy
resource "aws_iam_policy" "govuk_artefact_policy" {
  count       = "${var.create_sns_subscription ? 1 : 0}"
  name        = "govuk-artefact-policy"
  description = "Provides necessary access to the Lambda function."
  policy      = "${data.template_file.govuk_artefact_policy_template.rendered}"
}

# AWS SNS-Lambda Policy Attachment
resource "aws_iam_policy_attachment" "govuk_artefact_policy_attachment" {
  count      = "${var.create_sns_subscription ? 1 : 0}"
  name       = "govuk-artefact-policy-attachment"
  roles      = ["${aws_iam_role.govuk_artefact_lambda_role.name}"]
  policy_arn = "${aws_iam_policy.govuk_artefact_policy.arn}"
}

# AWS SNS Trigger for Lambda
resource "aws_lambda_permission" "govuk_artefact_lambda_sns" {
  count         = "${var.create_sns_subscription ? 1 : 0}"
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = "govuk-${var.aws_environment}-artefact"
  principal     = "sns.amazonaws.com"
  source_arn    = "arn:aws:sns:${var.aws_region}:${var.aws_subscription_account_id}:govuk-${var.artefact_source}-artefact"
  depends_on    = ["aws_lambda_function.artefact_lambda_function"]
}

# Artefact Writer
resource "aws_iam_policy" "artefact_writer" {
  name        = "govuk-${var.aws_environment}-artefact-writer-policy"
  policy      = "${data.template_file.artefact_writer_policy_template.rendered}"
  description = "Allows writing of the artefacts bucket"
}

# We require a user for the CI environment which is not in AWS
resource "aws_iam_user" "artefact_writer" {
  name = "govuk-${var.aws_environment}-artefact-writer"
}

resource "aws_iam_policy_attachment" "artefact_writer" {
  name       = "artefact-writer-policy-attachment"
  users      = ["${aws_iam_user.artefact_writer.name}"]
  policy_arn = "${aws_iam_policy.artefact_writer.arn}"
}

data "template_file" "artefact_writer_policy_template" {
  template = "${file("${path.module}/../../policies/artefact_writer_policy.tpl")}"

  vars {
    aws_environment = "${var.aws_environment}"
    artefact_bucket = "${aws_s3_bucket.artefact.id}"
  }
}

# Artefact Reader
resource "aws_iam_policy" "artefact_reader" {
  name        = "govuk-${var.aws_environment}-artefact-reader-policy"
  policy      = "${data.template_file.artefact_reader_policy_template.rendered}"
  description = "Allows writing of the artefacts bucket"
}

data "template_file" "artefact_reader_policy_template" {
  template = "${file("${path.module}/../../policies/artefact_reader_policy.tpl")}"

  vars {
    aws_environment = "${var.aws_environment}"
    artefact_bucket = "${aws_s3_bucket.artefact.id}"
  }
}

# Outputs
# --------------------------------------------------------------

output "write_artefact_bucket_policy_arn" {
  value       = "${aws_iam_policy.artefact_writer.arn}"
  description = "ARN of the write artefact-bucket policy"
}

output "read_artefact_bucket_policy_arn" {
  value       = "${aws_iam_policy.artefact_reader.arn}"
  description = "ARN of the read artefact-bucket policy"
}
