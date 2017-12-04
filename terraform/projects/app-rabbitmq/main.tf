/**
* ## Project: app-rabbitmq
*
* Rabbitmq cluster
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

variable "ssh_public_key" {
  type        = "string"
  description = "Default public key material"
}

variable "instance_ami_filter_name" {
  type        = "string"
  description = "Name to use to find AMI images"
  default     = ""
}

# Resources
# --------------------------------------------------------------
terraform {
  backend          "s3"             {}
  required_version = "= 0.11.1"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "1.0.0"
}

resource "aws_elb" "rabbitmq_elb" {
  name            = "${var.stackname}-rabbitmq-internal"
  subnets         = ["${data.terraform_remote_state.infra_networking.private_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_rabbitmq_elb_id}"]
  internal        = "true"

  access_logs {
    bucket        = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    bucket_prefix = "elb/${var.stackname}-rabbitmq-internal-elb"
    interval      = 60
  }

  listener {
    instance_port     = 5672
    instance_protocol = "tcp"
    lb_port           = 5672
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3

    target   = "TCP:5672"
    interval = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = "${map("Name", "${var.stackname}-rabbitmq-internal", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "rabbitmq")}"
}

resource "aws_route53_record" "rabbitmq_internal_service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.internal_zone_id}"
  name    = "rabbitmq.${data.terraform_remote_state.infra_stack_dns_zones.internal_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.rabbitmq_elb.dns_name}"
    zone_id                = "${aws_elb.rabbitmq_elb.zone_id}"
    evaluate_target_health = true
  }
}

module "rabbitmq" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-rabbitmq"
  vpc_id                        = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "rabbitmq", "aws_hostname", "rabbitmq")}"
  instance_subnet_ids           = "${data.terraform_remote_state.infra_networking.private_subnet_ids}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_rabbitmq_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "t2.medium"
  create_instance_key           = true
  instance_key_name             = "${var.stackname}-rabbitmq"
  instance_public_key           = "${var.ssh_public_key}"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids              = ["${aws_elb.rabbitmq_elb.id}"]
  instance_ami_filter_name      = "${var.instance_ami_filter_name}"
  root_block_device_volume_size = "20"
  asg_max_size                  = "3"
  asg_min_size                  = "3"
  asg_desired_capacity          = "3"
  asg_notification_topic_arn    = "${data.terraform_remote_state.infra_monitoring.sns_topic_autoscaling_group_events_arn}"
}

resource "aws_iam_policy" "rabbitmq_iam_policy" {
  name   = "${var.stackname}-rabbitmq-additional"
  path   = "/"
  policy = "${file("${path.module}/additional_policy.json")}"
}

resource "aws_iam_role_policy_attachment" "rabbitmq_iam_role_policy_attachment" {
  role       = "${module.rabbitmq.instance_iam_role_name}"
  policy_arn = "${aws_iam_policy.rabbitmq_iam_policy.arn}"
}

module "alarms-elb-rabbitmq-internal" {
  source                         = "../../modules/aws/alarms/elb"
  name_prefix                    = "${var.stackname}-rabbitmq-internal"
  alarm_actions                  = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  elb_name                       = "${aws_elb.rabbitmq_elb.name}"
  httpcode_backend_4xx_threshold = "0"
  httpcode_backend_5xx_threshold = "0"
  httpcode_elb_4xx_threshold     = "0"
  httpcode_elb_5xx_threshold     = "0"
  surgequeuelength_threshold     = "200"
  healthyhostcount_threshold     = "1"
}

# Outputs
# --------------------------------------------------------------

output "rabbitmq_internal_service_dns_name" {
  value       = "${aws_route53_record.rabbitmq_internal_service_record.fqdn}"
  description = "DNS name to access the rabbitmq internal service"
}
