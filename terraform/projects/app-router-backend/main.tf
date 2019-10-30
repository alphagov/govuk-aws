/**
* ## Project: app-router-backend
*
* Router backend hosts both Mongo and router-api
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

variable "router-backend_1_subnet" {
  type        = "string"
  description = "Name of the subnet to place the Router Mongo 1"
}

variable "router-backend_2_subnet" {
  type        = "string"
  description = "Name of the subnet to place the Router Mongo 2"
}

variable "router-backend_3_subnet" {
  type        = "string"
  description = "Name of the subnet to place the Router Mongo 3"
}

variable "router-backend_1_reserved_ips_subnet" {
  type        = "string"
  description = "Name of the subnet to place the reserved IP of the instance"
}

variable "router-backend_2_reserved_ips_subnet" {
  type        = "string"
  description = "Name of the subnet to place the reserved IP of the instance"
}

variable "router-backend_3_reserved_ips_subnet" {
  type        = "string"
  description = "Name of the subnet to place the reserved IP of the instance"
}

variable "router-backend_1_ip" {
  type        = "string"
  description = "IP address of the private IP to assign to the instance"
}

variable "router-backend_2_ip" {
  type        = "string"
  description = "IP address of the private IP to assign to the instance"
}

variable "router-backend_3_ip" {
  type        = "string"
  description = "IP address of the private IP to assign to the instance"
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

data "aws_acm_certificate" "elb_internal_cert" {
  domain   = "${var.elb_internal_certname}"
  statuses = ["ISSUED"]
}

resource "aws_elb" "router_api_elb" {
  name            = "${var.stackname}-router-api"
  subnets         = ["${data.terraform_remote_state.infra_networking.private_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_router-api_elb_id}"]
  internal        = "true"

  access_logs {
    bucket        = "${data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id}"
    bucket_prefix = "elb/${var.stackname}-router-api-internal-elb"
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

  tags = "${map("Name", "${var.stackname}-router-api", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "router_backend")}"
}

resource "aws_route53_record" "router_api_service_record" {
  zone_id = "${data.aws_route53_zone.internal.zone_id}"
  name    = "router-api.${var.internal_domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.router_api_elb.dns_name}"
    zone_id                = "${aws_elb.router_api_elb.zone_id}"
    evaluate_target_health = true
  }
}

# Instance 1
resource "aws_network_interface" "router-backend-1_eni" {
  subnet_id       = "${lookup(data.terraform_remote_state.infra_networking.private_subnet_reserved_ips_names_ids_map, var.router-backend_1_reserved_ips_subnet)}"
  private_ips     = ["${var.router-backend_1_ip}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_router-backend_id}"]

  tags {
    Name            = "${var.stackname}-router-backend-1"
    Project         = "${var.stackname}"
    aws_hostname    = "router-backend-1"
    aws_migration   = "router_backend"
    aws_stackname   = "${var.stackname}"
    aws_environment = "${var.aws_environment}"
  }
}

resource "aws_route53_record" "router-backend_1_service_record" {
  zone_id = "${data.aws_route53_zone.internal.zone_id}"
  name    = "router-backend-1.${var.internal_domain_name}"
  type    = "A"
  records = ["${var.router-backend_1_ip}"]
  ttl     = 300
}

module "router-backend-1" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-router-backend-1"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "router_backend", "aws_hostname", "router-backend-1")}"
  instance_subnet_ids           = "${matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.router-backend_1_subnet))}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_router-backend_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "${var.instance_type}"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids_length       = "1"
  instance_elb_ids              = ["${aws_elb.router_api_elb.id}"]
  instance_ami_filter_name      = "${var.instance_ami_filter_name}"
  asg_notification_topic_arn    = "${data.terraform_remote_state.infra_monitoring.sns_topic_autoscaling_group_events_arn}"
  root_block_device_volume_size = "20"
}

# Instance 2
resource "aws_network_interface" "router-backend-2_eni" {
  subnet_id       = "${lookup(data.terraform_remote_state.infra_networking.private_subnet_reserved_ips_names_ids_map, var.router-backend_2_reserved_ips_subnet)}"
  private_ips     = ["${var.router-backend_2_ip}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_router-backend_id}"]

  tags {
    Name            = "${var.stackname}-router-backend-2"
    Project         = "${var.stackname}"
    aws_hostname    = "router-backend-2"
    aws_migration   = "router_backend"
    aws_stackname   = "${var.stackname}"
    aws_environment = "${var.aws_environment}"
  }
}

resource "aws_route53_record" "router-backend_2_service_record" {
  zone_id = "${data.aws_route53_zone.internal.zone_id}"
  name    = "router-backend-2.${var.internal_domain_name}"
  type    = "A"
  records = ["${var.router-backend_2_ip}"]
  ttl     = 300
}

module "router-backend-2" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-router-backend-2"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "router_backend", "aws_hostname", "router-backend-2")}"
  instance_subnet_ids           = "${matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.router-backend_2_subnet))}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_router-backend_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "${var.instance_type}"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids_length       = "1"
  instance_elb_ids              = ["${aws_elb.router_api_elb.id}"]
  instance_ami_filter_name      = "${var.instance_ami_filter_name}"
  asg_notification_topic_arn    = "${data.terraform_remote_state.infra_monitoring.sns_topic_autoscaling_group_events_arn}"
  root_block_device_volume_size = "20"
}

# Instance 3
resource "aws_network_interface" "router-backend-3_eni" {
  subnet_id       = "${lookup(data.terraform_remote_state.infra_networking.private_subnet_reserved_ips_names_ids_map, var.router-backend_3_reserved_ips_subnet)}"
  private_ips     = ["${var.router-backend_3_ip}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_router-backend_id}"]

  tags {
    Name            = "${var.stackname}-router-backend-3"
    Project         = "${var.stackname}"
    aws_hostname    = "router-backend-3"
    aws_migration   = "router_backend"
    aws_stackname   = "${var.stackname}"
    aws_environment = "${var.aws_environment}"
  }
}

resource "aws_route53_record" "router-backend_3_service_record" {
  zone_id = "${data.aws_route53_zone.internal.zone_id}"
  name    = "router-backend-3.${var.internal_domain_name}"
  type    = "A"
  records = ["${var.router-backend_3_ip}"]
  ttl     = 300
}

module "router-backend-3" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-router-backend-3"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "router_backend", "aws_hostname", "router-backend-3")}"
  instance_subnet_ids           = "${matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.router-backend_3_subnet))}"
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_router-backend_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = "${var.instance_type}"
  instance_additional_user_data = "${join("\n", null_resource.user_data.*.triggers.snippet)}"
  instance_elb_ids_length       = "1"
  instance_elb_ids              = ["${aws_elb.router_api_elb.id}"]
  instance_ami_filter_name      = "${var.instance_ami_filter_name}"
  asg_notification_topic_arn    = "${data.terraform_remote_state.infra_monitoring.sns_topic_autoscaling_group_events_arn}"
  root_block_device_volume_size = "20"
}

module "alarms-elb-router-api-internal" {
  source                         = "../../modules/aws/alarms/elb"
  name_prefix                    = "${var.stackname}-router-api-internal"
  alarm_actions                  = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  elb_name                       = "${aws_elb.router_api_elb.name}"
  httpcode_backend_5xx_threshold = "100"
  httpcode_elb_4xx_threshold     = "100"
  httpcode_elb_5xx_threshold     = "100"
}

data "terraform_remote_state" "infra_database_backups_bucket" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket}"
    key    = "${coalesce(var.remote_state_infra_database_backups_bucket_key_stack, var.stackname)}/infra-database-backups-bucket.tfstate"
    region = "${var.aws_region}"
  }
}

resource "aws_iam_role_policy_attachment" "write_router-backend_database_backups_iam_role_policy_attachment" {
  count      = 3
  role       = "${element(list(module.router-backend-1.instance_iam_role_name, module.router-backend-2.instance_iam_role_name, module.router-backend-3.instance_iam_role_name), count.index)}"
  policy_arn = "${data.terraform_remote_state.infra_database_backups_bucket.mongo_router_write_database_backups_bucket_policy_arn}"
}

resource "aws_iam_role_policy_attachment" "read_integration_router-backend_database_backups_iam_role_policy_attachment" {
  count      = "${var.aws_environment == "integration" ? 3 : 0}"
  role       = "${element(list(module.router-backend-1.instance_iam_role_name, module.router-backend-2.instance_iam_role_name, module.router-backend-3.instance_iam_role_name), count.index)}"
  policy_arn = "${data.terraform_remote_state.infra_database_backups_bucket.integration_mongo_router_read_database_backups_bucket_policy_arn}"
}

resource "aws_iam_role_policy_attachment" "read_staging_router-backend_database_backups_iam_role_policy_attachment" {
  count      = "${var.aws_environment == "staging" ? 3 : 0}"
  role       = "${element(list(module.router-backend-1.instance_iam_role_name, module.router-backend-2.instance_iam_role_name, module.router-backend-3.instance_iam_role_name), count.index)}"
  policy_arn = "${data.terraform_remote_state.infra_database_backups_bucket.staging_mongo_router_read_database_backups_bucket_policy_arn}"
}

resource "aws_iam_role_policy_attachment" "staging_read_production_router-backend_database_backups_iam_role_policy_attachment" {
  count      = "${var.aws_environment == "staging" ? 3 : 0}"
  role       = "${element(list(module.router-backend-1.instance_iam_role_name, module.router-backend-2.instance_iam_role_name, module.router-backend-3.instance_iam_role_name), count.index)}"
  policy_arn = "${data.terraform_remote_state.infra_database_backups_bucket.production_mongo_router_read_database_backups_bucket_policy_arn}"
}

resource "aws_iam_policy" "router-backend_iam_policy" {
  name   = "${var.stackname}-router-backend-additional"
  path   = "/"
  policy = "${file("${path.module}/additional_policy.json")}"
}

resource "aws_iam_role_policy_attachment" "router-backend_iam_role_policy_attachment" {
  count      = 3
  role       = "${element(list(module.router-backend-1.instance_iam_role_name, module.router-backend-2.instance_iam_role_name, module.router-backend-3.instance_iam_role_name), count.index)}"
  policy_arn = "${aws_iam_policy.router-backend_iam_policy.arn}"
}

# Outputs
# --------------------------------------------------------------

output "router_api_service_dns_name" {
  value       = "${aws_route53_record.router_api_service_record.fqdn}"
  description = "DNS name to access the router-api internal service"
}

output "router_backend_1_service_dns_name" {
  value       = "${aws_route53_record.router-backend_1_service_record.fqdn}"
  description = "DNS name to access the Router Mongo 1 internal service"
}

output "router_backend_2_service_dns_name" {
  value       = "${aws_route53_record.router-backend_2_service_record.fqdn}"
  description = "DNS name to access the Router Mongo 2 internal service"
}

output "router_backend_3_service_dns_name" {
  value       = "${aws_route53_record.router-backend_3_service_record.fqdn}"
  description = "DNS name to access the Router Mongo 3 internal service"
}
