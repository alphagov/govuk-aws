/**
* ## Project: app-elasticsearch5
*
* Elasticsearch 5 cluster
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

variable "ebs_encrypted" {
  type        = "string"
  description = "Whether or not the EBS volume is encrypted"
}

variable "instance_ami_filter_name" {
  type        = "string"
  description = "Name to use to find AMI images"
  default     = ""
}

variable "elasticsearch5_1_subnet" {
  type        = "string"
  description = "Name of the subnet to place the Elasticsearch instance 1 and EBS volume"
}

variable "elasticsearch5_2_subnet" {
  type        = "string"
  description = "Name of the subnet to place the Elasticsearch 2 and EBS volume"
}

variable "elasticsearch5_3_subnet" {
  type        = "string"
  description = "Name of the subnet to place the Elasticsearch instance 3 and EBS volume"
}

variable "cluster_name" {
  type        = "string"
  description = "Name of the Elasticsearch cluster to use for discovery"
}

variable "elasticsearch5_1_backups_enabled" {
  type        = "string"
  description = "Whether or not this machine takes the ES backups"
  default     = "0"
}

variable "elasticsearch5_2_backups_enabled" {
  type        = "string"
  description = "Whether or not this machine takes the ES backups"
  default     = "0"
}

variable "elasticsearch5_3_backups_enabled" {
  type        = "string"
  description = "Whether or not this machine takes the ES backups"
  default     = "0"
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
  required_version = "= 0.11.7"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "1.40.0"
}

resource "aws_elb" "elasticsearch5_elb" {
  name            = "${var.stackname}-elasticsearch5"
  subnets         = ["${data.terraform_remote_state.infra_networking.private_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_elasticsearch5_elb_id}"]
  internal        = "true"

  access_logs {
    bucket        = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    bucket_prefix = "elb/${var.stackname}-elasticsearch5-internal-elb"
    interval      = 60
  }

  listener {
    instance_port     = 9200
    instance_protocol = "tcp"
    lb_port           = 9200
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3

    target   = "TCP:9200"
    interval = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = "${map("Name", "${var.stackname}-elasticsearch5", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "elasticsearch5")}"
}

resource "aws_route53_record" "service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.internal_zone_id}"
  name    = "elasticsearch5.${data.terraform_remote_state.infra_stack_dns_zones.internal_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.elasticsearch5_elb.dns_name}"
    zone_id                = "${aws_elb.elasticsearch5_elb.zone_id}"
    evaluate_target_health = true
  }
}

# Instance 1
module "elasticsearch5-1" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-elasticsearch5-1"
  vpc_id                        = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "elasticsearch5", "aws_hostname", "elasticsearch5-1", "cluster_name", var.cluster_name, "backups_enabled", var.elasticsearch5_1_backups_enabled)}"
  instance_subnet_ids           = "${matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.elasticsearch5_1_subnet))}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_elasticsearch5_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "m5.large"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids_length       = "1"
  instance_elb_ids              = ["${aws_elb.elasticsearch5_elb.id}"]
  instance_ami_filter_name      = "${var.instance_ami_filter_name}"
  asg_notification_topic_arn    = "${data.terraform_remote_state.infra_monitoring.sns_topic_autoscaling_group_events_arn}"
  root_block_device_volume_size = "20"
}

resource "aws_ebs_volume" "elasticsearch5-1" {
  availability_zone = "${lookup(data.terraform_remote_state.infra_networking.private_subnet_names_azs_map, var.elasticsearch5_1_subnet)}"
  encrypted         = "${var.ebs_encrypted}"
  size              = 100
  type              = "gp2"

  tags {
    Name            = "${var.stackname}-elasticsearch5-1"
    Project         = "${var.stackname}"
    aws_stackname   = "${var.stackname}"
    aws_environment = "${var.aws_environment}"
    aws_migration   = "elasticsearch5"
    aws_hostname    = "elasticsearch5-1"
    Device          = "xvdf"
  }
}

# Instance 2
module "elasticsearch5-2" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-elasticsearch5-2"
  vpc_id                        = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "elasticsearch5", "aws_hostname", "elasticsearch5-2", "cluster_name", var.cluster_name, "backups_enabled", var.elasticsearch5_2_backups_enabled)}"
  instance_subnet_ids           = "${matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.elasticsearch5_2_subnet))}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_elasticsearch5_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "m5.large"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids_length       = "1"
  instance_elb_ids              = ["${aws_elb.elasticsearch5_elb.id}"]
  instance_ami_filter_name      = "${var.instance_ami_filter_name}"
  asg_notification_topic_arn    = "${data.terraform_remote_state.infra_monitoring.sns_topic_autoscaling_group_events_arn}"
  root_block_device_volume_size = "20"
}

resource "aws_ebs_volume" "elasticsearch5-2" {
  availability_zone = "${lookup(data.terraform_remote_state.infra_networking.private_subnet_names_azs_map, var.elasticsearch5_2_subnet)}"
  encrypted         = "${var.ebs_encrypted}"
  size              = 100
  type              = "gp2"

  tags {
    Name            = "${var.stackname}-elasticsearch5-2"
    Project         = "${var.stackname}"
    aws_stackname   = "${var.stackname}"
    aws_environment = "${var.aws_environment}"
    aws_migration   = "elasticsearch5"
    aws_hostname    = "elasticsearch5-2"
    Device          = "xvdf"
  }
}

# Instance 3
module "elasticsearch5-3" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-elasticsearch5-3"
  vpc_id                        = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "elasticsearch5", "aws_hostname", "elasticsearch5-3", "cluster_name", var.cluster_name, "backups_enabled", var.elasticsearch5_3_backups_enabled)}"
  instance_subnet_ids           = "${matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.elasticsearch5_3_subnet))}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_elasticsearch5_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "m5.large"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids_length       = "1"
  instance_elb_ids              = ["${aws_elb.elasticsearch5_elb.id}"]
  instance_ami_filter_name      = "${var.instance_ami_filter_name}"
  asg_notification_topic_arn    = "${data.terraform_remote_state.infra_monitoring.sns_topic_autoscaling_group_events_arn}"
  root_block_device_volume_size = "20"
}

resource "aws_ebs_volume" "elasticsearch5-3" {
  availability_zone = "${lookup(data.terraform_remote_state.infra_networking.private_subnet_names_azs_map, var.elasticsearch5_3_subnet)}"
  encrypted         = "${var.ebs_encrypted}"
  size              = 100
  type              = "gp2"

  tags {
    Name            = "${var.stackname}-elasticsearch5-3"
    Project         = "${var.stackname}"
    aws_stackname   = "${var.stackname}"
    aws_environment = "${var.aws_environment}"
    aws_migration   = "elasticsearch5"
    aws_hostname    = "elasticsearch5-3"
    Device          = "xvdf"
  }
}

resource "aws_iam_policy" "elasticsearch5_iam_policy" {
  name   = "${var.stackname}-elasticsearch5-additional"
  path   = "/"
  policy = "${file("${path.module}/additional_policy.json")}"
}

resource "aws_iam_role_policy_attachment" "elasticsearch5_1_iam_role_policy_attachment" {
  role       = "${module.elasticsearch5-1.instance_iam_role_name}"
  policy_arn = "${aws_iam_policy.elasticsearch5_iam_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "elasticsearch5_2_iam_role_policy_attachment" {
  role       = "${module.elasticsearch5-2.instance_iam_role_name}"
  policy_arn = "${aws_iam_policy.elasticsearch5_iam_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "elasticsearch5_3_iam_role_policy_attachment" {
  role       = "${module.elasticsearch5-3.instance_iam_role_name}"
  policy_arn = "${aws_iam_policy.elasticsearch5_iam_policy.arn}"
}

module "alarms-elb-elasticsearch5-internal" {
  source                         = "../../modules/aws/alarms/elb"
  name_prefix                    = "${var.stackname}-elasticsearch5-internal"
  alarm_actions                  = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  elb_name                       = "${aws_elb.elasticsearch5_elb.name}"
  httpcode_backend_4xx_threshold = "0"
  httpcode_backend_5xx_threshold = "0"
  httpcode_elb_4xx_threshold     = "0"
  httpcode_elb_5xx_threshold     = "0"
  surgequeuelength_threshold     = "200"
  healthyhostcount_threshold     = "1"
}

data "terraform_remote_state" "infra_database_backups_bucket" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket}"
    key    = "${coalesce(var.remote_state_infra_database_backups_bucket_key_stack, var.stackname)}/infra-database-backups-bucket.tfstate"
    region = "eu-west-1"
  }
}

resource "aws_iam_role_policy_attachment" "write_elasticsearch5-1_database_backups_iam_role_policy_attachment" {
  count      = 3
  role       = "${element(list(module.elasticsearch5-1.instance_iam_role_name, module.elasticsearch5-2.instance_iam_role_name, module.elasticsearch5-3.instance_iam_role_name), count.index)}"
  policy_arn = "${data.terraform_remote_state.infra_database_backups_bucket.elasticsearch_write_database_backups_bucket_policy_arn}"
}

resource "aws_iam_role_policy_attachment" "integration_read_elasticsearch5-1_database_backups_iam_role_policy_attachment" {
  count      = "${var.aws_environment == "integration" ? 3 : 0}"
  role       = "${element(list(module.elasticsearch5-1.instance_iam_role_name, module.elasticsearch5-2.instance_iam_role_name, module.elasticsearch5-3.instance_iam_role_name), count.index)}"
  policy_arn = "${data.terraform_remote_state.infra_database_backups_bucket.integration_elasticsearch_read_database_backups_bucket_policy_arn}"
}

resource "aws_iam_role_policy_attachment" "staging_read_elasticsearch5-1_database_backups_iam_role_policy_attachment" {
  count      = "${var.aws_environment == "staging" ? 3 : 0}"
  role       = "${element(list(module.elasticsearch5-1.instance_iam_role_name, module.elasticsearch5-2.instance_iam_role_name, module.elasticsearch5-3.instance_iam_role_name), count.index)}"
  policy_arn = "${data.terraform_remote_state.infra_database_backups_bucket.staging_elasticsearch_read_database_backups_bucket_policy_arn}"
}

# Outputs
# --------------------------------------------------------------

output "service_dns_name" {
  value       = "${aws_route53_record.service_record.fqdn}"
  description = "DNS name to access the Elasticsearch internal service"
}

output "elasticsearch5_elb_dns_name" {
  value       = "${aws_elb.elasticsearch5_elb.dns_name}"
  description = "DNS name to access the Elasticsearch ELB"
}
