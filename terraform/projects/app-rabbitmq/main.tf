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

variable "federation" {
  type        = "string"
  description = "Whether we do RabbitMQ federation or not"
  default     = "false"
}

variable "instance_ami_filter_name" {
  type        = "string"
  description = "Name to use to find AMI images"
  default     = ""
}

variable "internal_zone_name" {
  type        = "string"
  description = "The name of the Route53 zone that contains internal records"
}

variable "internal_domain_name" {
  type        = "string"
  description = "The domain name of the internal DNS records, it could be different from the zone name"
}

variable "instance_type" {
  type        = "string"
  description = "Instance type used for EC2 resources"
  default     = "t2.medium"
}

variable "rabbitmq_1_reserved_ips_subnet" {
  default     = ""
  type        = "string"
  description = "Name of the subnet to place the reserved IP of the instance"
}

variable "rabbitmq_2_reserved_ips_subnet" {
  default     = ""
  type        = "string"
  description = "Name of the subnet to place the reserved IP of the instance"
}

variable "rabbitmq_3_reserved_ips_subnet" {
  default     = ""
  type        = "string"
  description = "Name of the subnet to place the reserved IP of the instance"
}

variable "rabbitmq_1_ip" {
  default     = ""
  type        = "string"
  description = "IP address of the private IP to assign to the instance"
}

variable "rabbitmq_2_ip" {
  default     = ""
  type        = "string"
  description = "IP address of the private IP to assign to the instance"
}

variable "rabbitmq_3_ip" {
  default     = ""
  type        = "string"
  description = "IP address of the private IP to assign to the instance"
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

data "aws_route53_zone" "internal" {
  name         = "${var.internal_zone_name}"
  private_zone = true
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
  zone_id = "${data.aws_route53_zone.internal.zone_id}"
  name    = "rabbitmq.${var.internal_domain_name}"
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
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "rabbitmq", "aws_hostname", "rabbitmq")}"
  instance_subnet_ids           = "${data.terraform_remote_state.infra_networking.private_subnet_ids}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_rabbitmq_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "${var.instance_type}"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids_length       = "1"
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

# Interface 1
resource "aws_network_interface" "rabbitmq-1_eni" {
  count           = "${var.federation ? 1 : 0}"
  subnet_id       = "${lookup(data.terraform_remote_state.infra_networking.private_subnet_reserved_ips_names_ids_map, var.rabbitmq_1_reserved_ips_subnet)}"
  private_ips     = ["${var.rabbitmq_1_ip}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_rabbitmq_id}"]

  tags {
    Name            = "${var.stackname}-rabbitmq"
    Project         = "${var.stackname}"
    aws_hostname    = "rabbitmq"
    aws_migration   = "rabbitmq"
    aws_stackname   = "${var.stackname}"
    aws_environment = "${var.aws_environment}"
  }
}

# Interface 2
resource "aws_network_interface" "rabbitmq-2_eni" {
  count           = "${var.federation ? 1 : 0}"
  subnet_id       = "${lookup(data.terraform_remote_state.infra_networking.private_subnet_reserved_ips_names_ids_map, var.rabbitmq_2_reserved_ips_subnet)}"
  private_ips     = ["${var.rabbitmq_2_ip}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_rabbitmq_id}"]

  tags {
    Name            = "${var.stackname}-rabbitmq"
    Project         = "${var.stackname}"
    aws_hostname    = "rabbitmq"
    aws_migration   = "rabbitmq"
    aws_stackname   = "${var.stackname}"
    aws_environment = "${var.aws_environment}"
  }
}

# Interface 3
resource "aws_network_interface" "rabbitmq-3_eni" {
  count           = "${var.federation ? 1 : 0}"
  subnet_id       = "${lookup(data.terraform_remote_state.infra_networking.private_subnet_reserved_ips_names_ids_map, var.rabbitmq_3_reserved_ips_subnet)}"
  private_ips     = ["${var.rabbitmq_3_ip}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_rabbitmq_id}"]

  tags {
    Name            = "${var.stackname}-rabbitmq"
    Project         = "${var.stackname}"
    aws_hostname    = "rabbitmq"
    aws_migration   = "rabbitmq"
    aws_stackname   = "${var.stackname}"
    aws_environment = "${var.aws_environment}"
  }
}

# Outputs
# --------------------------------------------------------------

output "rabbitmq_internal_service_dns_name" {
  value       = "${aws_route53_record.rabbitmq_internal_service_record.fqdn}"
  description = "DNS name to access the rabbitmq internal service"
}
