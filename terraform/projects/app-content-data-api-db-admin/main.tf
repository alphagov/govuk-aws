/**
* ## Project: app-content-data-api-db-admin
*
* DB admin boxes for the Content Data API RDS instance
*/
variable "aws_region" {
  type        = "string"
  description = "AWS region"
  default     = "eu-west-1"
}

variable "stackname" {
  type        = "string"
  description = "Stackname"
}

variable "aws_environment" {
  type        = "string"
  description = "AWS Environment"
}

variable "remote_state_infra_database_backups_bucket_key_stack" {
  type        = "string"
  description = "Override stackname path to infra_database_backups_bucket remote state"
  default     = ""
}

variable "instance_type" {
  type        = "string"
  description = "Instance type used for EC2 resources"
  default     = "t2.medium"
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

module "content-data-api-db-admin" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-content-data-api-db-admin"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "content_data_api_db_admin", "aws_hostname", "content-data-api-db-admin-1")}"
  instance_subnet_ids           = "${data.terraform_remote_state.infra_networking.private_subnet_ids}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_content-data-api-db-admin_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "${var.instance_type}"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids_length       = "0"
  instance_elb_ids              = []
  asg_max_size                  = "1"
  asg_min_size                  = "1"
  asg_desired_capacity          = "1"
  asg_notification_topic_arn    = "${data.terraform_remote_state.infra_monitoring.sns_topic_autoscaling_group_events_arn}"
  root_block_device_volume_size = "64"
}

module "alarms-autoscaling-content-data-api-db-admin" {
  source                            = "../../modules/aws/alarms/autoscaling"
  name_prefix                       = "${var.stackname}-content-data-api-db-admin"
  autoscaling_group_name            = "${module.content-data-api-db-admin.autoscaling_group_name}"
  alarm_actions                     = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  groupinserviceinstances_threshold = "1"
}

module "alarms-ec2-content-data-api-db-admin" {
  source                   = "../../modules/aws/alarms/ec2"
  name_prefix              = "${var.stackname}-content-data-api-db-admin"
  autoscaling_group_name   = "${module.content-data-api-db-admin.autoscaling_group_name}"
  alarm_actions            = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  cpuutilization_threshold = "85"
}

data "terraform_remote_state" "infra_database_backups_bucket" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket}"
    key    = "${coalesce(var.remote_state_infra_database_backups_bucket_key_stack, var.stackname)}/infra-database-backups-bucket.tfstate"
    region = "${var.aws_region}"
  }
}

# All environments should be able to write to the backups bucket for
# the respective environment.
resource "aws_iam_role_policy_attachment" "write_to_database_backups_bucket_iam_role_policy_attachment" {
  role       = "${module.content-data-api-db-admin.instance_iam_role_name}"
  policy_arn = "${data.terraform_remote_state.infra_database_backups_bucket.content_data_api_dbadmin_write_database_backups_bucket_policy_arn}"
}

# All environments should be able to read from the production database
# backups bucket, to enable restoring the backups, and the overnight
# data syncs.
resource "aws_iam_role_policy_attachment" "read_from_production_database_backups_from_production_iam_role_policy_attachment" {
  role       = "${module.content-data-api-db-admin.instance_iam_role_name}"
  policy_arn = "${data.terraform_remote_state.infra_database_backups_bucket.production_content_data_api_dbadmin_read_database_backups_bucket_policy_arn}"
}
