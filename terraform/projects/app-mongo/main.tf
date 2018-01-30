/**
* ## Project: app-mongo
*
* Mongo hosts
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

variable "instance_ami_filter_name" {
  type        = "string"
  description = "Name to use to find AMI images"
  default     = ""
}

variable "mongo_1_subnet" {
  type        = "string"
  description = "Name of the subnet to place the Mongo instance 1 and EBS volume"
}

variable "mongo_2_subnet" {
  type        = "string"
  description = "Name of the subnet to place the Mongo 2 and EBS volume"
}

variable "mongo_3_subnet" {
  type        = "string"
  description = "Name of the subnet to place the Mongo 3 and EBS volume"
}

variable "mongo_1_reserved_ips_subnet" {
  type        = "string"
  description = "Name of the subnet to place the reserved IP of the instance"
}

variable "mongo_2_reserved_ips_subnet" {
  type        = "string"
  description = "Name of the subnet to place the reserved IP of the instance"
}

variable "mongo_3_reserved_ips_subnet" {
  type        = "string"
  description = "Name of the subnet to place the reserved IP of the instance"
}

variable "mongo_1_ip" {
  type        = "string"
  description = "IP address of the private IP to assign to the instance"
}

variable "mongo_2_ip" {
  type        = "string"
  description = "IP address of the private IP to assign to the instance"
}

variable "mongo_3_ip" {
  type        = "string"
  description = "IP address of the private IP to assign to the instance"
}

variable "remote_state_infra_database_backups_bucket_key_stack" {
  type        = "string"
  description = "Override stackname path to infra_database_backups_bucket remote state"
  default     = ""
}

# Resources
# --------------------------------------------------------------
terraform {
  backend          "s3"             {}
  required_version = "= 0.11.2"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "1.0.0"
}

# Instance 1
resource "aws_network_interface" "mongo-1_eni" {
  subnet_id       = "${lookup(data.terraform_remote_state.infra_networking.private_subnet_reserved_ips_names_ids_map, var.mongo_1_reserved_ips_subnet)}"
  private_ips     = ["${var.mongo_1_ip}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_mongo_id}"]

  tags {
    Name            = "${var.stackname}-mongo-1"
    Project         = "${var.stackname}"
    aws_hostname    = "mongo-1"
    aws_migration   = "mongo"
    aws_stackname   = "${var.stackname}"
    aws_environment = "${var.aws_environment}"
  }
}

resource "aws_route53_record" "mongo_1_service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.internal_zone_id}"
  name    = "mongo-1.${data.terraform_remote_state.infra_stack_dns_zones.internal_domain_name}"
  type    = "A"
  records = ["${var.mongo_1_ip}"]
  ttl     = 300
}

module "mongo-1" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-mongo-1"
  vpc_id                        = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "mongo", "aws_hostname", "mongo-1")}"
  instance_subnet_ids           = "${matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.mongo_1_subnet))}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_mongo_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "m5.large"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids_length       = "0"
  instance_elb_ids              = []
  instance_ami_filter_name      = "${var.instance_ami_filter_name}"
  asg_notification_topic_arn    = "${data.terraform_remote_state.infra_monitoring.sns_topic_autoscaling_group_events_arn}"
  root_block_device_volume_size = "150"
}

# Instance 2
resource "aws_network_interface" "mongo-2_eni" {
  subnet_id       = "${lookup(data.terraform_remote_state.infra_networking.private_subnet_reserved_ips_names_ids_map, var.mongo_2_reserved_ips_subnet)}"
  private_ips     = ["${var.mongo_2_ip}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_mongo_id}"]

  tags {
    Name            = "${var.stackname}-mongo-2"
    Project         = "${var.stackname}"
    aws_hostname    = "mongo-2"
    aws_migration   = "mongo"
    aws_stackname   = "${var.stackname}"
    aws_environment = "${var.aws_environment}"
  }
}

resource "aws_route53_record" "mongo_2_service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.internal_zone_id}"
  name    = "mongo-2.${data.terraform_remote_state.infra_stack_dns_zones.internal_domain_name}"
  type    = "A"
  records = ["${var.mongo_2_ip}"]
  ttl     = 300
}

module "mongo-2" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-mongo-2"
  vpc_id                        = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "mongo", "aws_hostname", "mongo-2")}"
  instance_subnet_ids           = "${matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.mongo_2_subnet))}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_mongo_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "m5.large"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids_length       = "0"
  instance_elb_ids              = []
  instance_ami_filter_name      = "${var.instance_ami_filter_name}"
  asg_notification_topic_arn    = "${data.terraform_remote_state.infra_monitoring.sns_topic_autoscaling_group_events_arn}"
  root_block_device_volume_size = "150"
}

# Instance 3
resource "aws_network_interface" "mongo-3_eni" {
  subnet_id       = "${lookup(data.terraform_remote_state.infra_networking.private_subnet_reserved_ips_names_ids_map, var.mongo_3_reserved_ips_subnet)}"
  private_ips     = ["${var.mongo_3_ip}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_mongo_id}"]

  tags {
    Name            = "${var.stackname}-mongo-3"
    Project         = "${var.stackname}"
    aws_hostname    = "mongo-3"
    aws_migration   = "mongo"
    aws_stackname   = "${var.stackname}"
    aws_environment = "${var.aws_environment}"
  }
}

resource "aws_route53_record" "mongo_3_service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.internal_zone_id}"
  name    = "mongo-3.${data.terraform_remote_state.infra_stack_dns_zones.internal_domain_name}"
  type    = "A"
  records = ["${var.mongo_3_ip}"]
  ttl     = 300
}

module "mongo-3" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-mongo-3"
  vpc_id                        = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "mongo", "aws_hostname", "mongo-3")}"
  instance_subnet_ids           = "${matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.mongo_3_subnet))}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_mongo_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "m5.large"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids_length       = "0"
  instance_elb_ids              = []
  instance_ami_filter_name      = "${var.instance_ami_filter_name}"
  asg_notification_topic_arn    = "${data.terraform_remote_state.infra_monitoring.sns_topic_autoscaling_group_events_arn}"
  root_block_device_volume_size = "150"
}

resource "aws_iam_policy" "mongo-iam_policy" {
  name   = "${var.stackname}-mongo-additional"
  path   = "/"
  policy = "${file("${path.module}/additional_policy.json")}"
}

resource "aws_iam_role_policy_attachment" "mongo-1_iam_role_policy_attachment" {
  role       = "${module.mongo-1.instance_iam_role_name}"
  policy_arn = "${aws_iam_policy.mongo-iam_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "mongo-2_iam_role_policy_attachment" {
  role       = "${module.mongo-2.instance_iam_role_name}"
  policy_arn = "${aws_iam_policy.mongo-iam_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "mongo-3_iam_role_policy_attachment" {
  role       = "${module.mongo-3.instance_iam_role_name}"
  policy_arn = "${aws_iam_policy.mongo-iam_policy.arn}"
}

module "alarms-autoscaling-mongo-1" {
  source                            = "../../modules/aws/alarms/autoscaling"
  name_prefix                       = "${var.stackname}-mongo-1"
  autoscaling_group_name            = "${module.mongo-1.autoscaling_group_name}"
  alarm_actions                     = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  groupinserviceinstances_threshold = "1"
}

module "alarms-ec2-mongo-1" {
  source                   = "../../modules/aws/alarms/ec2"
  name_prefix              = "${var.stackname}-mongo-1"
  autoscaling_group_name   = "${module.mongo-1.autoscaling_group_name}"
  alarm_actions            = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  cpuutilization_threshold = "85"
}

module "alarms-autoscaling-mongo-2" {
  source                            = "../../modules/aws/alarms/autoscaling"
  name_prefix                       = "${var.stackname}-mongo-2"
  autoscaling_group_name            = "${module.mongo-2.autoscaling_group_name}"
  alarm_actions                     = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  groupinserviceinstances_threshold = "1"
}

module "alarms-ec2-mongo-2" {
  source                   = "../../modules/aws/alarms/ec2"
  name_prefix              = "${var.stackname}-mongo-2"
  autoscaling_group_name   = "${module.mongo-2.autoscaling_group_name}"
  alarm_actions            = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  cpuutilization_threshold = "85"
}

module "alarms-autoscaling-mongo-3" {
  source                            = "../../modules/aws/alarms/autoscaling"
  name_prefix                       = "${var.stackname}-mongo-3"
  autoscaling_group_name            = "${module.mongo-3.autoscaling_group_name}"
  alarm_actions                     = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  groupinserviceinstances_threshold = "1"
}

module "alarms-ec2-mongo-3" {
  source                   = "../../modules/aws/alarms/ec2"
  name_prefix              = "${var.stackname}-mongo-3"
  autoscaling_group_name   = "${module.mongo-3.autoscaling_group_name}"
  alarm_actions            = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  cpuutilization_threshold = "85"
}

data "terraform_remote_state" "infra_database_backups_bucket" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket}"
    key    = "${coalesce(var.remote_state_infra_database_backups_bucket_key_stack, var.stackname)}/infra-database-backups-bucket.tfstate"
    region = "eu-west-1"
  }
}

resource "aws_iam_role_policy_attachment" "mongo_database_backups_iam_role_policy_attachment" {
  count      = 3
  role       = "${element(list(module.mongo-1.instance_iam_role_name, module.mongo-2.instance_iam_role_name, module.mongo-3.instance_iam_role_name), count.index)}"
  policy_arn = "${data.terraform_remote_state.infra_database_backups_bucket.write_database_backups_bucket_policy_arn}"
}

# Outputs
# --------------------------------------------------------------

output "mongo_1_service_dns_name" {
  value       = "${aws_route53_record.mongo_1_service_record.fqdn}"
  description = "DNS name to access the Mongo 1 internal service"
}

output "mongo_2_service_dns_name" {
  value       = "${aws_route53_record.mongo_2_service_record.fqdn}"
  description = "DNS name to access the Mongo 2 internal service"
}

output "mongo_3_service_dns_name" {
  value       = "${aws_route53_record.mongo_3_service_record.fqdn}"
  description = "DNS name to access the Mongo 3 internal service"
}
