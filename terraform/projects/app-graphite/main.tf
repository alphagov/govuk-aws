/**
* ## Project: app-graphite
*
* Graphite node
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

variable "graphite_1_subnet" {
  type        = "string"
  description = "Name of the subnet to place the Graphite instance 1 and EBS volume"
}

variable "elb_external_certname" {
  type        = "string"
  description = "The ACM cert domain name to find the ARN of"
}

variable "elb_internal_certname" {
  type        = "string"
  description = "The ACM cert domain name to find the ARN of"
}

variable "remote_state_infra_database_backups_bucket_key_stack" {
  type        = "string"
  description = "Override stackname path to infra_database_backups_bucket remote state"
  default     = ""
}

variable "external_zone_name" {
  type        = "string"
  description = "The name of the Route53 zone that contains external records"
}

variable "external_domain_name" {
  type        = "string"
  description = "The domain name of the external DNS records, it could be different from the zone name"
}

variable "internal_zone_name" {
  type        = "string"
  description = "The name of the Route53 zone that contains internal records"
}

variable "internal_domain_name" {
  type        = "string"
  description = "The domain name of the internal DNS records, it could be different from the zone name"
}

variable "create_external_elb" {
  description = "Create the external ELB"
  default     = true
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

data "aws_route53_zone" "external" {
  name         = "${var.external_zone_name}"
  private_zone = false
}

data "aws_route53_zone" "internal" {
  name         = "${var.internal_zone_name}"
  private_zone = true
}

data "aws_acm_certificate" "elb_external_cert" {
  domain   = "${var.elb_external_certname}"
  statuses = ["ISSUED"]
}

data "aws_acm_certificate" "elb_internal_cert" {
  domain   = "${var.elb_internal_certname}"
  statuses = ["ISSUED"]
}

resource "aws_elb" "graphite_external_elb" {
  count = "${var.create_external_elb}"

  name            = "${var.stackname}-graphite-external"
  subnets         = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_graphite_external_elb_id}"]
  internal        = "false"

  access_logs {
    bucket        = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    bucket_prefix = "elb/${var.stackname}-graphite-external-elb"
    interval      = 60
  }

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 443
    lb_protocol       = "https"

    ssl_certificate_id = "${data.aws_acm_certificate.elb_external_cert.arn}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3

    target   = "TCP:80"
    interval = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = "${map("Name", "${var.stackname}-graphite-external", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "graphite")}"
}

resource "aws_route53_record" "graphite_external_service_record" {
  count = "${var.create_external_elb}"

  zone_id = "${data.aws_route53_zone.external.zone_id}"
  name    = "graphite.${var.external_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.graphite_external_elb.dns_name}"
    zone_id                = "${aws_elb.graphite_external_elb.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "grafana_external_service_record" {
  count = "${var.create_external_elb}"

  zone_id = "${data.aws_route53_zone.external.zone_id}"
  name    = "grafana.${var.external_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.graphite_external_elb.dns_name}"
    zone_id                = "${aws_elb.graphite_external_elb.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_elb" "graphite_internal_elb" {
  name            = "${var.stackname}-graphite-internal"
  subnets         = ["${data.terraform_remote_state.infra_networking.private_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_graphite_internal_elb_id}"]
  internal        = "true"

  access_logs {
    bucket        = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    bucket_prefix = "elb/${var.stackname}-graphite-internal-elb"
    interval      = 60
  }

  listener {
    instance_port     = 2003
    instance_protocol = "tcp"
    lb_port           = 2003
    lb_protocol       = "tcp"
  }

  listener {
    instance_port     = 2004
    instance_protocol = "tcp"
    lb_port           = 2004
    lb_protocol       = "tcp"
  }

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 443
    lb_protocol       = "https"

    ssl_certificate_id = "${data.aws_acm_certificate.elb_internal_cert.arn}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3

    target   = "TCP:2003"
    interval = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = "${map("Name", "${var.stackname}-graphite-internal", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "graphite")}"
}

resource "aws_route53_record" "graphite_internal_service_record" {
  zone_id = "${data.aws_route53_zone.internal.zone_id}"
  name    = "graphite.${var.internal_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.graphite_internal_elb.dns_name}"
    zone_id                = "${aws_elb.graphite_internal_elb.zone_id}"
    evaluate_target_health = true
  }
}

locals {
  instance_elb_ids_length = "${var.create_external_elb ? 2 : 1}"
  instance_elb_ids        = "${compact(list(aws_elb.graphite_internal_elb.id, join("", aws_elb.graphite_external_elb.*.id)))}"
}

module "graphite-1" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-graphite-1"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "graphite", "aws_hostname", "graphite-1")}"
  instance_subnet_ids           = "${matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.graphite_1_subnet))}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_graphite_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "${var.instance_type}"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids_length       = "${local.instance_elb_ids_length}"
  instance_elb_ids              = ["${local.instance_elb_ids}"]
  instance_ami_filter_name      = "${var.instance_ami_filter_name}"
  asg_notification_topic_arn    = "${data.terraform_remote_state.infra_monitoring.sns_topic_autoscaling_group_events_arn}"
}

resource "aws_ebs_volume" "graphite-1" {
  availability_zone = "${lookup(data.terraform_remote_state.infra_networking.private_subnet_names_azs_map, var.graphite_1_subnet)}"
  encrypted         = "${var.ebs_encrypted}"
  size              = 250
  type              = "io1"
  iops              = 1000

  tags {
    Name            = "${var.stackname}-graphite-1"
    Project         = "${var.stackname}"
    Device          = "xvdf"
    aws_stackname   = "${var.stackname}"
    aws_environment = "${var.aws_environment}"
    aws_migration   = "graphite"
    aws_hostname    = "graphite-1"
  }
}

resource "aws_iam_policy" "graphite_1_iam_policy" {
  name   = "${var.stackname}-graphite-1-additional"
  path   = "/"
  policy = "${file("${path.module}/additional_policy.json")}"
}

resource "aws_iam_role_policy_attachment" "graphite_1_iam_role_policy_attachment" {
  role       = "${module.graphite-1.instance_iam_role_name}"
  policy_arn = "${aws_iam_policy.graphite_1_iam_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "graphite_1_iam_role_policy_cloudwatch_attachment" {
  role       = "${module.graphite-1.instance_iam_role_name}"
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "write_graphite_database_backups_iam_role_policy_attachment" {
  count      = 1
  role       = "${module.graphite-1.instance_iam_role_name}"
  policy_arn = "${data.terraform_remote_state.infra_database_backups_bucket.graphite_write_database_backups_bucket_policy_arn}"
}

resource "aws_iam_role_policy_attachment" "read_integration_graphite_database_backups_iam_role_policy_attachment" {
  count      = "${var.aws_environment == "integration" ? 1 : 0}"
  role       = "${module.graphite-1.instance_iam_role_name}"
  policy_arn = "${data.terraform_remote_state.infra_database_backups_bucket.integration_graphite_read_database_backups_bucket_policy_arn}"
}

resource "aws_iam_role_policy_attachment" "read_staging_graphite_database_backups_iam_role_policy_attachment" {
  count      = "${var.aws_environment == "staging" ? 1 : 0}"
  role       = "${module.graphite-1.instance_iam_role_name}"
  policy_arn = "${data.terraform_remote_state.infra_database_backups_bucket.staging_graphite_read_database_backups_bucket_policy_arn}"
}

data "terraform_remote_state" "infra_database_backups_bucket" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket}"
    key    = "${coalesce(var.remote_state_infra_database_backups_bucket_key_stack, var.stackname)}/infra-database-backups-bucket.tfstate"
    region = "${var.aws_region}"
  }
}

module "alarms-elb-graphite-internal" {
  source                         = "../../modules/aws/alarms/elb"
  name_prefix                    = "${var.stackname}-graphite-internal"
  alarm_actions                  = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  elb_name                       = "${aws_elb.graphite_internal_elb.name}"
  httpcode_backend_4xx_threshold = "0"
  httpcode_backend_5xx_threshold = "100"
  httpcode_elb_4xx_threshold     = "100"
  httpcode_elb_5xx_threshold     = "100"
  surgequeuelength_threshold     = "200"
  healthyhostcount_threshold     = "1"
}

locals {
  elb_httpcode_backend_5xx_threshold = "${var.create_external_elb ? 100 : 0}"
  elb_httpcode_elb_5xx_threshold     = "${var.create_external_elb ? 100 : 0}"
}

module "alarms-elb-graphite-external" {
  source                         = "../../modules/aws/alarms/elb"
  name_prefix                    = "${var.stackname}-graphite-external"
  alarm_actions                  = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  elb_name                       = "${join("", aws_elb.graphite_external_elb.*.name)}"
  httpcode_backend_4xx_threshold = "0"
  httpcode_backend_5xx_threshold = "${local.elb_httpcode_backend_5xx_threshold}"
  httpcode_elb_4xx_threshold     = "0"
  httpcode_elb_5xx_threshold     = "${local.elb_httpcode_elb_5xx_threshold}"
  surgequeuelength_threshold     = "0"
  healthyhostcount_threshold     = "0"
}

# Outputs
# --------------------------------------------------------------

output "graphite_internal_service_dns_name" {
  value       = "${aws_route53_record.graphite_internal_service_record.fqdn}"
  description = "DNS name to access the Graphite internal service"
}

output "graphite_external_elb_dns_name" {
  value       = "${join("", aws_route53_record.graphite_external_service_record.*.fqdn)}"
  description = "DNS name to access the Graphite external service"
}
