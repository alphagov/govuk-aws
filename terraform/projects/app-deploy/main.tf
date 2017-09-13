# == Manifest: projects::app-puppetmaster
#
# Deploy node
#
# === Variables:
#
# aws_region
# stackname
# aws_environment
# ssh_public_key
# instance_ami_filter_name
# elb_certname
#
# === Outputs:
#

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

variable "elb_certname" {
  type        = "string"
  description = "The ACM cert domain name to find the ARN of"
}

variable "remote_state_infra_artefact_bucket_stack" {
  type        = "string"
  description = "Override infra_artefact_bucket remote state path"
  default     = ""
}

# Resources
# --------------------------------------------------------------
terraform {
  backend          "s3"             {}
  required_version = "= 0.9.10"
}

# This is one of two places that should need to use this particular remote state
# so keep it in main
data "terraform_remote_state" "artefact_bucket" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket}"
    key    = "${coalesce(var.remote_state_infra_artefact_bucket_stack, var.stackname)}/artefact-bucket.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  region = "${var.aws_region}"
}

data "aws_acm_certificate" "elb_cert" {
  domain   = "${var.elb_certname}"
  statuses = ["ISSUED"]
}

resource "aws_elb" "deploy_elb" {
  name            = "${var.stackname}-deploy"
  subnets         = ["${data.terraform_remote_state.infra_networking.public_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_deploy_elb_id}"]
  internal        = "false"

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 443
    lb_protocol       = "https"

    ssl_certificate_id = "${data.aws_acm_certificate.elb_cert.arn}"
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

  tags = "${map("Name", "${var.stackname}-deploy", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "jenkins")}"
}

module "deploy" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-deploy"
  vpc_id                        = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "jenkins", "aws_hostname", "jenkins-1")}"
  instance_subnet_ids           = "${data.terraform_remote_state.infra_networking.private_subnet_ids}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_deploy_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "t2.medium"
  create_instance_key           = true
  instance_key_name             = "${var.stackname}-deploy"
  instance_public_key           = "${var.ssh_public_key}"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids              = ["${aws_elb.deploy_elb.id}"]
  instance_ami_filter_name      = "${var.instance_ami_filter_name}"
}

resource "aws_route53_record" "service_record" {
  zone_id = "${data.terraform_remote_state.infra_stack_dns_zones.external_zone_id}"
  name    = "deploy.${data.terraform_remote_state.infra_stack_dns_zones.external_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.deploy_elb.dns_name}"
    zone_id                = "${aws_elb.deploy_elb.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_iam_role_policy_attachment" "attach_read_artefact_bucket_policy" {
  role       = "${module.deploy.instance_iam_role_name}"
  policy_arn = "${data.terraform_remote_state.artefact_bucket.read_artefact_bucket_policy_arn}"
}

# Outputs
# --------------------------------------------------------------

output "deploy_elb_dns_name" {
  value       = "${aws_elb.deploy_elb.dns_name}"
  description = "DNS name to access the deploy service"
}
