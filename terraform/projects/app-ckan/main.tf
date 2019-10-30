/**
* ## Project: app-ckan
*
* CKAN node
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

variable "ebs_encrypted" {
  type        = "string"
  description = "Whether or not the EBS volume is encrypted"
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

variable "elb_internal_certname" {
  type        = "string"
  description = "The ACM cert domain name to find the ARN of"
}

variable "elb_external_certname" {
  type        = "string"
  description = "The ACM cert domain name to find the ARN of"
}

variable "app_service_records" {
  type        = "list"
  description = "List of application service names that get traffic via this loadbalancer"
  default     = []
}

variable "ckan_subnet" {
  type        = "string"
  description = "Name of the subnet to place the ckan instance and the EBS volume"
}

variable "instance_type" {
  type        = "string"
  description = "Instance type used for EC2 resources"
  default     = "m5.xlarge"
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

data "aws_acm_certificate" "elb_external_cert" {
  domain   = "${var.elb_external_certname}"
  statuses = ["ISSUED"]
}

data "aws_acm_certificate" "elb_internal_cert" {
  domain   = "${var.elb_internal_certname}"
  statuses = ["ISSUED"]
}

resource "aws_elb" "ckan_elb_external" {
  name            = "${var.stackname}-ckan-external"
  subnets         = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_ckan_elb_external_id}"]
  internal        = "false"

  access_logs {
    bucket        = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    bucket_prefix = "elb/${var.stackname}-ckan-external-elb"
    interval      = 60
  }

  listener {
    instance_port     = "80"
    instance_protocol = "http"
    lb_port           = "443"
    lb_protocol       = "https"

    ssl_certificate_id = "${data.aws_acm_certificate.elb_external_cert.arn}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:80"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = "${map("Name", "${var.stackname}-ckan", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "ckan")}"
}

resource "aws_route53_record" "service_record_external" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.external_zone_id}"
  name    = "ckan.${data.terraform_remote_state.infra_stack_dns_zones.external_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.ckan_elb_external.dns_name}"
    zone_id                = "${aws_elb.ckan_elb_external.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "app_service_records_external" {
  count   = "${length(var.app_service_records)}"
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.external_zone_id}"
  name    = "${element(var.app_service_records, count.index)}.${data.terraform_remote_state.infra_stack_dns_zones.external_domain_name}"
  type    = "CNAME"
  records = ["ckan.${data.terraform_remote_state.infra_stack_dns_zones.external_domain_name}"]
  ttl     = "300"
}

resource "aws_elb" "ckan_elb_internal" {
  name            = "${var.stackname}-ckan-internal"
  subnets         = ["${data.terraform_remote_state.infra_networking.private_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_ckan_elb_internal_id}"]
  internal        = "true"

  access_logs {
    bucket        = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    bucket_prefix = "elb/${var.stackname}-ckan-internal-elb"
    interval      = 60
  }

  listener {
    instance_port     = "80"
    instance_protocol = "http"
    lb_port           = "443"
    lb_protocol       = "https"

    ssl_certificate_id = "${data.aws_acm_certificate.elb_internal_cert.arn}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:80"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = "${map("Name", "${var.stackname}-ckan", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "ckan")}"
}

resource "aws_route53_record" "service_record_internal" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.internal_zone_id}"
  name    = "ckan.${data.terraform_remote_state.infra_stack_dns_zones.internal_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.ckan_elb_internal.dns_name}"
    zone_id                = "${aws_elb.ckan_elb_internal.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "app_service_records_internal" {
  count   = "${length(var.app_service_records)}"
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.internal_zone_id}"
  name    = "${element(var.app_service_records, count.index)}.${data.terraform_remote_state.infra_stack_dns_zones.internal_domain_name}"
  type    = "CNAME"
  records = ["ckan.${data.terraform_remote_state.infra_stack_dns_zones.internal_domain_name}"]
  ttl     = "300"
}

module "ckan" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-ckan"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "ckan", "aws_hostname", "ckan-1")}"
  instance_subnet_ids           = "${matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.ckan_subnet))}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_ckan_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "${var.instance_type}"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids_length       = "2"
  instance_elb_ids              = ["${aws_elb.ckan_elb_internal.id}", "${aws_elb.ckan_elb_external.id}"]
  instance_ami_filter_name      = "${var.instance_ami_filter_name}"
  asg_notification_topic_arn    = "${data.terraform_remote_state.infra_monitoring.sns_topic_autoscaling_group_events_arn}"
}

resource "aws_ebs_volume" "ckan" {
  availability_zone = "${lookup(data.terraform_remote_state.infra_networking.private_subnet_names_azs_map, var.ckan_subnet)}"
  encrypted         = "${var.ebs_encrypted}"
  type              = "gp2"
  size              = 20

  tags {
    Name            = "${var.stackname}-ckan"
    Project         = "${var.stackname}"
    ManagedBy       = "terraform"
    aws_stackname   = "${var.stackname}"
    aws_environment = "${var.aws_environment}"
    aws_migration   = "ckan"
    aws_hostname    = "ckan-1"
    Device          = "xvdf"
  }
}

resource "aws_iam_policy" "ckan-iam_policy" {
  name   = "${var.stackname}-ckan-additional"
  path   = "/"
  policy = "${file("${path.module}/additional_policy.json")}"
}

resource "aws_iam_role_policy_attachment" "ckan_iam_role_policy_attachment" {
  role       = "${module.ckan.instance_iam_role_name}"
  policy_arn = "${aws_iam_policy.ckan-iam_policy.arn}"
}

module "alarms-elb-ckan-internal" {
  source                         = "../../modules/aws/alarms/elb"
  name_prefix                    = "${var.stackname}-ckan-internal"
  alarm_actions                  = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  elb_name                       = "${aws_elb.ckan_elb_internal.name}"
  httpcode_backend_4xx_threshold = "0"
  httpcode_backend_5xx_threshold = "100"
  httpcode_elb_4xx_threshold     = "100"
  httpcode_elb_5xx_threshold     = "100"
  surgequeuelength_threshold     = "0"
  healthyhostcount_threshold     = "0"
}

module "alarms-elb-ckan-external" {
  source                         = "../../modules/aws/alarms/elb"
  name_prefix                    = "${var.stackname}-ckan-external"
  alarm_actions                  = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  elb_name                       = "${aws_elb.ckan_elb_external.name}"
  httpcode_backend_4xx_threshold = "0"
  httpcode_backend_5xx_threshold = "100"
  httpcode_elb_4xx_threshold     = "100"
  httpcode_elb_5xx_threshold     = "100"
  surgequeuelength_threshold     = "0"
  healthyhostcount_threshold     = "0"
}

# Outputs
# --------------------------------------------------------------

output "ckan_elb_internal_address" {
  value       = "${aws_elb.ckan_elb_internal.dns_name}"
  description = "AWS' internal DNS name for the ckan ELB"
}

output "service_dns_name_internal" {
  value       = "${aws_route53_record.service_record_internal.name}"
  description = "DNS name to access the node service"
}

output "app_service_records_internal_dns_name" {
  value       = "${aws_route53_record.app_service_records_internal.*.name}"
  description = "DNS name to access the app service records"
}

output "ckan_elb_external_address" {
  value       = "${aws_elb.ckan_elb_external.dns_name}"
  description = "AWS' external DNS name for the ckan ELB"
}

output "service_dns_name_external" {
  value       = "${aws_route53_record.service_record_external.name}"
  description = "DNS name to access the node service"
}

output "app_service_records_external_dns_name" {
  value       = "${aws_route53_record.app_service_records_external.*.name}"
  description = "DNS name to access the app service records"
}
