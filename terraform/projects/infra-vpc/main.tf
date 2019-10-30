/**
* ## Module: projects/infra-vpc
*
* Creates the base VPC layer for an AWS stack, with VPC flow logs
* and resources to export these logs to S3
*/

variable "aws_region" {
  type        = "string"
  description = "AWS region"
  default     = "eu-west-1"
}

variable "stackname" {
  type        = "string"
  description = "Stackname"
  default     = ""
}

variable "vpc_name" {
  type        = "string"
  description = "A name tag for the VPC"
}

variable "vpc_cidr" {
  type        = "string"
  description = "VPC IP address range, represented as a CIDR block"
}

variable "traffic_type" {
  type        = "string"
  description = "The traffic type to capture. Allows ACCEPT, ALL or REJECT"
  default     = "REJECT"
}

variable "cloudwatch_log_retention" {
  type        = "string"
  description = "Number of days to retain Cloudwatch logs for"
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

data "terraform_remote_state" "infra_monitoring" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket}"
    key    = "${coalesce(var.remote_state_infra_monitoring_key_stack, var.stackname)}/infra-monitoring.tfstate"
    region = "${var.aws_region}"
  }
}

module "vpc" {
  source       = "../../modules/aws/network/vpc"
  name         = "${var.vpc_name}"
  cidr         = "${var.vpc_cidr}"
  default_tags = "${map("Project", var.stackname)}"
}

resource "aws_cloudwatch_log_group" "log" {
  name              = "${var.stackname}-vpc-flow-log"
  retention_in_days = "${var.cloudwatch_log_retention}"

  tags {
    Project       = "${var.stackname}"
    aws_stackname = "${var.stackname}"
  }
}

resource "aws_flow_log" "vpc_flow_log" {
  log_destination = "${aws_cloudwatch_log_group.log.arn}"
  iam_role_arn    = "${aws_iam_role.vpc_flow_logs_role.arn}"
  vpc_id          = "${module.vpc.vpc_id}"
  traffic_type    = "${var.traffic_type}"
}

resource "aws_iam_role" "vpc_flow_logs_role" {
  name               = "${var.stackname}-vpc-flow-logs"
  assume_role_policy = "${file("${path.module}/../../policies/vpc_flow_logs_assume_policy.json")}"
}

resource "aws_iam_policy" "vpc_flow_logs_policy" {
  name   = "${var.stackname}-vpc-flow-logs-policy"
  path   = "/"
  policy = "${file("${path.module}/../../policies/vpc_flow_logs_policy.json")}"
}

resource "aws_iam_role_policy_attachment" "vpc_flow_logs_policy_attachment" {
  role       = "${aws_iam_role.vpc_flow_logs_role.name}"
  policy_arn = "${aws_iam_policy.vpc_flow_logs_policy.arn}"
}

module "vpc_flow_log_exporter" {
  source                       = "../../modules/aws/cloudwatch_log_exporter"
  log_group_name               = "${aws_cloudwatch_log_group.log.name}"
  firehose_role_arn            = "${data.terraform_remote_state.infra_monitoring.firehose_logs_role_arn}"
  firehose_bucket_arn          = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_arn}"
  firehose_bucket_prefix       = "${aws_cloudwatch_log_group.log.name}"
  lambda_filename              = "../../lambda/VPCFlowLogsToFirehose/VPCFlowLogsToFirehose.zip"
  lambda_role_arn              = "${data.terraform_remote_state.infra_monitoring.lambda_logs_role_arn}"
  lambda_log_retention_in_days = "${var.cloudwatch_log_retention}"
}

# Outputs
# --------------------------------------------------------------

output "vpc_id" {
  value       = "${module.vpc.vpc_id}"
  description = "The ID of the VPC"
}

output "vpc_cidr" {
  value       = "${module.vpc.vpc_cidr}"
  description = "The CIDR block of the VPC"
}

output "internet_gateway_id" {
  value       = "${module.vpc.internet_gateway_id}"
  description = "The ID of the Internet Gateway"
}

output "route_table_public_id" {
  value       = "${module.vpc.route_table_public_id}"
  description = "The ID of the public routing table"
}
