/**
* ## Project: app-ci-master
*
* CI Master Node
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

variable "elb_external_certname" {
  type        = "string"
  description = "The ACM cert domain name to find the ARN of, will be attached to external classic ELB"
}

variable "elb_internal_certname" {
  type        = "string"
  description = "The ACM cert domain name to find the ARN of, will be attached to internal classic ELB"
}

variable "elb_public_certname" {
  type        = "string"
  description = "The ACM cert domain name to find the ARN of, will be attached to external ALB"
}

variable "elb_public_secondary_certname" {
  type        = "string"
  description = "The ACM secondary cert domain name to find the ARN of, will be attached to external ALB"
}

variable "deploy_subnet" {
  type        = "string"
  description = "Name of the subnet to place the ci and EBS volume"
}

variable "remote_state_infra_artefact_bucket_key_stack" {
  type        = "string"
  description = "Override infra_artefact_bucket remote state path"
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
  default     = "t2.medium"
}

variable "public_service_names" {
  type        = "list"
  description = "list of public names for ci-master, used for DNS domain"
  default     = ["ci"]
}

variable "internal_service_names" {
  type        = "list"
  description = "list of internal names for ci-master, used for DNS domain"
  default     = ["ci"]
}

# Resources
# --------------------------------------------------------------
terraform {
  backend          "s3"             {}
  required_version = "= 0.11.14"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "2.46.0"
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

resource "aws_elb" "ci-master_elb" {
  count = "${var.create_external_elb}"

  name            = "${var.stackname}-ci-master"
  subnets         = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_ci-master_elb_id}"]
  internal        = "false"

  access_logs {
    bucket        = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    bucket_prefix = "elb/${var.stackname}-ci-master-external-elb"
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

  tags = "${map("Name", "${var.stackname}-ci-master", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "ci_master")}"
}

data "aws_acm_certificate" "elb_internal_cert" {
  domain   = "${var.elb_internal_certname}"
  statuses = ["ISSUED"]
}

resource "aws_elb" "ci-master_internal_elb" {
  name            = "${var.stackname}-ci-master-internal"
  subnets         = ["${data.terraform_remote_state.infra_networking.private_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_ci-master_internal_elb_id}"]
  internal        = "true"

  access_logs {
    bucket        = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    bucket_prefix = "elb/${var.stackname}-ci-master-internal-elb"
    interval      = 60
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

    target   = "TCP:80"
    interval = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = "${map("Name", "${var.stackname}-ci-master-internal", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "ci_master")}"
}

resource "aws_route53_record" "service_record" {
  count = "${var.create_external_elb}"

  zone_id = "${data.aws_route53_zone.external.zone_id}"
  name    = "ci.${var.external_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.ci-master_elb.dns_name}"
    zone_id                = "${aws_elb.ci-master_elb.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "service_record_internal" {
  zone_id = "${data.aws_route53_zone.internal.zone_id}"
  name    = "ci.${var.internal_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.ci-master_internal_elb.dns_name}"
    zone_id                = "${aws_elb.ci-master_internal_elb.zone_id}"
    evaluate_target_health = true
  }
}

locals {
  instance_elb_ids_length = "${var.create_external_elb ? 2 : 1}"
  instance_elb_ids        = "${compact(list(join("", aws_elb.ci-master_elb.*.id), aws_elb.ci-master_internal_elb.id))}"
}

module "ci-master" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-ci-master"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "ci_master", "aws_hostname", "ci-master-1")}"
  instance_subnet_ids           = "${matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.deploy_subnet))}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_ci-master_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "${var.instance_type}"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids_length       = "${local.instance_elb_ids_length}"
  instance_elb_ids              = ["${local.instance_elb_ids}"]
  instance_ami_filter_name      = "${var.instance_ami_filter_name}"
  asg_notification_topic_arn    = "${data.terraform_remote_state.infra_monitoring.sns_topic_autoscaling_group_events_arn}"
}

resource "aws_ebs_volume" "ci-master" {
  availability_zone = "${lookup(data.terraform_remote_state.infra_networking.private_subnet_names_azs_map, var.deploy_subnet)}"
  encrypted         = "${var.ebs_encrypted}"
  size              = 40
  type              = "gp2"

  tags {
    Name            = "${var.stackname}-ci"
    Project         = "${var.stackname}"
    Device          = "xvdf"
    aws_hostname    = "ci-master-1"
    aws_migration   = "ci_master"
    aws_stackname   = "${var.stackname}"
    aws_environment = "${var.aws_environment}"
  }
}

resource "aws_iam_policy" "ci-master_iam_policy" {
  name   = "${var.stackname}-ci-master-additional"
  path   = "/"
  policy = "${file("${path.module}/additional_policy.json")}"
}

resource "aws_iam_role_policy_attachment" "ci-master_iam_role_policy_attachment" {
  role       = "${module.ci-master.instance_iam_role_name}"
  policy_arn = "${aws_iam_policy.ci-master_iam_policy.arn}"
}

locals {
  elb_httpcode_backend_5xx_threshold = "${var.create_external_elb ? 50 : 0}"
  elb_httpcode_elb_5xx_threshold     = "${var.create_external_elb ? 50 : 0}"
}

module "alarms-elb-ci-master-external" {
  source                         = "../../modules/aws/alarms/elb"
  name_prefix                    = "${var.stackname}-ci-master-external"
  alarm_actions                  = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  elb_name                       = "${join("", aws_elb.ci-master_elb.*.name)}"
  httpcode_backend_4xx_threshold = "0"
  httpcode_backend_5xx_threshold = "${local.elb_httpcode_backend_5xx_threshold}"
  httpcode_elb_4xx_threshold     = "0"
  httpcode_elb_5xx_threshold     = "${local.elb_httpcode_elb_5xx_threshold}"
  surgequeuelength_threshold     = "0"
  healthyhostcount_threshold     = "0"
}

//Public ALB and configs: we do not put it in infra-public-services as this project should
//ideally only be deployed in integration
module "ci_master_public_lb" {
  source                                     = "../../modules/aws/lb"
  name                                       = "govuk-ci-master-public"
  internal                                   = false
  vpc_id                                     = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  access_logs_bucket_name                    = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
  access_logs_bucket_prefix                  = "elb/govuk-ci-master-public-elb"
  listener_certificate_domain_name           = "${var.elb_public_certname}"
  listener_secondary_certificate_domain_name = "${var.elb_public_secondary_certname}"
  listener_action                            = "${map("HTTPS:443", "HTTP:80")}"
  subnets                                    = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups                            = ["${data.terraform_remote_state.infra_security_groups.sg_ci-master_elb_id}"]
  alarm_actions                              = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  default_tags                               = "${map("Project", "govuk", "aws_migration", "ci_master", "aws_environment", var.aws_environment)}"
}

resource "aws_route53_record" "ci_master_public_service_names" {
  count   = "${length(var.public_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.external_root_zone_id}"
  name    = "${element(var.public_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.external_root_domain_name}"
  type    = "A"

  alias {
    name                   = "${module.ci_master_public_lb.lb_dns_name}"
    zone_id                = "${module.ci_master_public_lb.lb_zone_id}"
    evaluate_target_health = true
  }
}

data "aws_autoscaling_groups" "ci_master" {
  filter {
    name   = "key"
    values = ["Name"]
  }

  filter {
    name   = "value"
    values = ["${var.stackname}-ci-master"]
  }
}

resource "aws_autoscaling_attachment" "ci_master_asg_attachment_alb" {
  count                  = "${length(data.aws_autoscaling_groups.ci_master.names) > 0 ? 1 : 0}"
  autoscaling_group_name = "${element(data.aws_autoscaling_groups.ci_master.names, 0)}"
  alb_target_group_arn   = "${element(module.ci_master_public_lb.target_group_arns, 0)}"
}

resource "aws_route53_record" "ci_master_internal_service_names" {
  count   = "${length(var.internal_service_names)}"
  zone_id = "${data.terraform_remote_state.infra_root_dns_zones.internal_root_zone_id}"
  name    = "${element(var.internal_service_names, count.index)}.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"
  type    = "CNAME"
  records = ["${element(var.internal_service_names, count.index)}.blue.${data.terraform_remote_state.infra_root_dns_zones.internal_root_domain_name}"]
  ttl     = "300"
}

# Outputs
# --------------------------------------------------------------

output "ci-master_elb_dns_name" {
  value       = "${join("", aws_elb.ci-master_elb.*.dns_name)}"
  description = "DNS name to access the ci-master service"
}
