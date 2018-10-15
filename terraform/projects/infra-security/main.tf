/**
* ## Module: projects/infra-security
*
* Infrastructure security settings:
*  - Create admin role for trusted users from GDS proxy account
*  - Create users role for trusted users from GDS proxy account
*  - Default IAM password policy
*  - Default SSH key
*  - CloudTrail settings and alarms
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

variable "role_admin_user_arns" {
  type        = "list"
  description = "List of ARNs of external users that can assume the role"
  default     = []
}

variable "role_admin_policy_arns" {
  type        = "list"
  description = "List of ARNs of policies to attach to the role"
  default     = []
}

variable "role_poweruser_user_arns" {
  type        = "list"
  description = "List of ARNs of external users that can assume the role"
  default     = []
}

variable "role_poweruser_policy_arns" {
  type        = "list"
  description = "List of ARNs of policies to attach to the role"
  default     = []
}

variable "role_user_user_arns" {
  type        = "list"
  description = "List of ARNs of external users that can assume the role"
  default     = []
}

variable "role_user_policy_arns" {
  type        = "list"
  description = "List of ARNs of policies to attach to the role"
  default     = []
}

variable "ssh_public_key" {
  type        = "string"
  description = "The public part of an SSH keypair"
}

# Resources
# --------------------------------------------------------------

terraform {
  backend          "s3"             {}
  required_version = "= 0.11.7"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "1.40.0"
}

module "role_admin" {
  source           = "../../modules/aws/iam/role_user"
  role_name        = "govuk-administrators"
  role_user_arns   = ["${var.role_admin_user_arns}"]
  role_policy_arns = ["${var.role_admin_policy_arns}"]
}

module "role_poweruser" {
  source           = "../../modules/aws/iam/role_user"
  role_name        = "govuk-powerusers"
  role_user_arns   = ["${var.role_poweruser_user_arns}"]
  role_policy_arns = ["${var.role_poweruser_policy_arns}"]
}

module "role_user" {
  source           = "../../modules/aws/iam/role_user"
  role_name        = "govuk-users"
  role_user_arns   = ["${var.role_user_user_arns}"]
  role_policy_arns = ["${var.role_user_policy_arns}"]
}

resource "aws_iam_account_password_policy" "tighten_passwords" {
  allow_users_to_change_password = true
  minimum_password_length        = 12
  require_lowercase_characters   = true
  require_numbers                = true
  require_symbols                = true
  require_uppercase_characters   = true
}

# default key pair for all ssh instances. All other keys are puppet managed
resource "aws_key_pair" "govuk-infra-key" {
  key_name   = "govuk-infra"
  public_key = "${var.ssh_public_key}"
}

# CloudTrail configuration
resource "aws_cloudwatch_log_group" "cloudtrail" {
  name              = "CloudTrail/logs"
  retention_in_days = "90"

  tags {
    Project       = "${var.stackname}"
    aws_stackname = "${var.stackname}"
  }
}

resource "aws_iam_role" "cloudtrail_cloudwatch_logs_role" {
  name               = "${var.stackname}-cloudtrail-cloudwatch-logs"
  path               = "/"
  assume_role_policy = "${file("${path.module}/../../policies/cloudtrail_assume_policy.json")}"
}

data "template_file" "cloudtrail_cloudwatch_logs_policy_template" {
  template = "${file("${path.module}/../../policies/cloudtrail_cloudwatch_logs_policy.tpl")}"

  vars {
    cloudwatch_log_group_arn = "${aws_cloudwatch_log_group.cloudtrail.arn}"
  }
}

resource "aws_iam_policy" "cloudtrail_cloudwatch_logs_policy" {
  name   = "${var.stackname}-cloudtrail-cloudwatch-logs"
  path   = "/"
  policy = "${data.template_file.cloudtrail_cloudwatch_logs_policy_template.rendered}"
}

resource "aws_iam_role_policy_attachment" "cloudtrail_cloudwatch_logs_policy_attachment" {
  role       = "${aws_iam_role.cloudtrail_cloudwatch_logs_role.name}"
  policy_arn = "${aws_iam_policy.cloudtrail_cloudwatch_logs_policy.arn}"
}

data "template_file" "cloudtrail_s3_policy_template" {
  template = "${file("${path.module}/../../policies/cloudtrail_s3_policy.tpl")}"

  vars {
    bucket_name = "${var.stackname}-${var.aws_environment}-cloudtrail"
  }
}

resource "aws_s3_bucket" "cloudtrail" {
  bucket = "${var.stackname}-${var.aws_environment}-cloudtrail"
  acl    = "private"
  policy = "${data.template_file.cloudtrail_s3_policy_template.rendered}"

  tags {
    Name        = "${var.stackname}-${var.aws_environment}-cloudtrail"
    Environment = "${var.aws_environment}"
  }
}

resource "aws_cloudtrail" "cloudtrail" {
  name                          = "CloudTrail-all-regions"
  s3_bucket_name                = "${aws_s3_bucket.cloudtrail.id}"
  include_global_service_events = true
  is_multi_region_trail         = true
  cloud_watch_logs_role_arn     = "${aws_iam_role.cloudtrail_cloudwatch_logs_role.arn}"
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.cloudtrail.arn}"
  enable_log_file_validation    = true
}

resource "aws_sns_topic" "cloudtrail" {
  name = "${var.stackname}-cloudtrail-security"
}

# CouldTrail security alarms

module "cloudtrail-alarm-authorization-failures" {
  source                    = "../../modules/aws/alarms/cloudtrail"
  cloudtrail_log_group_name = "${aws_cloudwatch_log_group.cloudtrail.name}"
  metric_filter_pattern     = "{ ($.errorCode = \"*UnauthorizedOperation\") || ($.errorCode = \"AccessDenied*\") }"
  metric_name               = "AuthorizationFailureCount"
  alarm_name                = "${var.stackname}-cloudtrail-authorization-failures"
  alarm_description         = "Alarms when an unauthorized API call is made."
  alarm_actions             = ["${aws_sns_topic.cloudtrail.arn}"]
}

module "cloudtrail-alarm-console-sign-in-failures" {
  source                    = "../../modules/aws/alarms/cloudtrail"
  cloudtrail_log_group_name = "${aws_cloudwatch_log_group.cloudtrail.name}"
  metric_filter_pattern     = "{ ($.eventName = \"ConsoleLogin\") && ($.errorMessage = \"Failed*\") }"
  metric_name               = "ConsoleSignInFailureCount"
  alarm_name                = "${var.stackname}-cloudtrail-console-sign-in-failures"
  alarm_description         = "Alarms when an unauthenticated API call is made to sign into the console."
  alarm_actions             = ["${aws_sns_topic.cloudtrail.arn}"]
}

module "cloudtrail-alarm-authorization-single-factor" {
  source                    = "../../modules/aws/alarms/cloudtrail"
  cloudtrail_log_group_name = "${aws_cloudwatch_log_group.cloudtrail.name}"
  metric_filter_pattern     = "{ ($.eventName = \"ConsoleLogin\") && ($.additionalEventData.MFAUsed != \"Yes\") }"
  metric_name               = "AuthorizationSingleFactorCount"
  alarm_name                = "${var.stackname}-cloudtrail-authorization-single-factor"
  alarm_description         = "Alarms when a login without MFA is made."
  alarm_actions             = ["${aws_sns_topic.cloudtrail.arn}"]
}

module "cloudtrail-alarm-root-account" {
  source                    = "../../modules/aws/alarms/cloudtrail"
  cloudtrail_log_group_name = "${aws_cloudwatch_log_group.cloudtrail.name}"
  metric_filter_pattern     = "{ $.userIdentity.type = \"Root\" && $.userIdentity.invokedBy NOT EXISTS && $.eventType != \"AwsServiceEvent\" }"
  metric_name               = "RootAccessEventCount"
  alarm_name                = "${var.stackname}-cloudtrail-root-event"
  alarm_description         = "Alarms when the root account is used."
  alarm_actions             = ["${aws_sns_topic.cloudtrail.arn}"]
}
