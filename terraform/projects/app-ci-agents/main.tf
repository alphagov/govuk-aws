/**
* ## Project: app-ci-agents
*
* CI agents
*/
variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-1"
}

variable "stackname" {
  type        = string
  description = "Stackname"
}

variable "aws_environment" {
  type        = string
  description = "AWS Environment"
}

variable "instance_ami_filter_name" {
  type        = string
  description = "Name to use to find AMI images"
  default     = ""
}

variable "elb_internal_certname" {
  type        = string
  description = "The ACM cert domain name to find the ARN of"
}

variable "internal_app_service_records" {
  type        = list(string)
  description = "List of application service names that get traffic via this loadbalancer"
  default     = []
}

variable "instance_type" {
  type        = string
  description = "Instance type used for EC2 resources"
  default     = "m5.2xlarge"
}

variable "internal_zone_name" {
  type        = string
  description = "The name of the Route53 zone that contains internal records"
}

variable "internal_domain_name" {
  type        = string
  description = "The domain name of the internal DNS records, it could be different from the zone name"
}

variable "root_block_device_volume_size" {
  type        = string
  description = "size of the root volume in GB"
  default     = "50"
}

variable "data_block_device_volume_size" {
  type        = string
  description = "Size of the data volume in GB"
  default     = "130"
}

variable "docker_block_device_volume_size" {
  type        = string
  description = "Size of the Docker volume in GB"
  default     = "130"
}

variable "ebs_volume_type" {
  type        = string
  description = "Volume type to use for data and Docker EBS volumes; see https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-volume-types.html"
  default     = "gp3"
}

variable "ebs_encrypted" {
  type        = string
  description = "whether or not the EBS volume is encrypted"
  default     = "true"
}

variable "ci_agent_1_subnet" {
  type        = string
  description = "subnet to deploy EC2 and EBS of CI agent 1"
  default     = "govuk_private_a"
}

variable "ci_agent_2_subnet" {
  type        = string
  description = "subnet to deploy EC2 and EBS of CI agent 2"
  default     = "govuk_private_b"
}

variable "ci_agent_3_subnet" {
  type        = string
  description = "subnet to deploy EC2 and EBS of CI agent 3"
  default     = "govuk_private_c"
}

variable "ci_agent_4_subnet" {
  type        = string
  description = "subnet to deploy EC2 and EBS of CI agent 4"
  default     = "govuk_private_a"
}

variable "ci_agent_5_subnet" {
  type        = string
  description = "subnet to deploy EC2 and EBS of CI agent 5"
  default     = "govuk_private_b"
}

# Resources
# --------------------------------------------------------------
terraform {
  backend "s3" {}
  required_version = "= 0.11.15"
}

data "aws_route53_zone" "internal" {
  name         = var.internal_zone_name
  private_zone = true
}

provider "aws" {
  region  = var.aws_region
  version = "2.46.0"
}

data "aws_acm_certificate" "elb_cert" {
  domain   = var.elb_internal_certname
  statuses = ["ISSUED"]
}

resource "aws_iam_policy" "ci-agent_iam_policy" {
  name   = "${var.stackname}-ci-agent-volume"
  path   = "/"
  policy = file("${path.module}/volume_policy.json")
}

/////////////////////ci-agent-1/////////////////////////////////////////////////

resource "aws_elb" "ci-agent-1_elb" {
  name            = "${var.stackname}-ci-agent-1"
  subnets         = ["${matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.ci_agent_1_subnet))}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_ci-agent-1_elb_id}"]
  internal        = "true"

  access_logs {
    bucket        = data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id
    bucket_prefix = "elb/${var.stackname}-ci-agent-1-internal-elb"
    interval      = 60
  }

  listener {
    instance_port     = 22
    instance_protocol = "tcp"
    lb_port           = 22
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3

    target   = "TCP:22"
    interval = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = "${map("Name", "${var.stackname}-ci-agent-1", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "ci-agent")}"
}

resource "aws_route53_record" "ci-agent-1_service_record" {
  zone_id = data.aws_route53_zone.internal.zone_id
  name    = "ci-agent-1.${var.internal_domain_name}"
  type    = "A"

  alias {
    name                   = aws_elb.ci-agent-1_elb.dns_name
    zone_id                = aws_elb.ci-agent-1_elb.zone_id
    evaluate_target_health = true
  }
}

module "ci-agent-1" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-ci-agent-1"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "ci_agent", "aws_hostname", "ci-agent-1")}"
  instance_subnet_ids           = matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.ci_agent_1_subnet))
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_ci-agent-1_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = var.instance_type
  instance_additional_user_data = join("\n", null_resource.user_data.*.triggers.snippet)
  instance_elb_ids_length       = "1"
  instance_elb_ids              = ["${aws_elb.ci-agent-1_elb.id}"]
  instance_ami_filter_name      = var.instance_ami_filter_name
  asg_max_size                  = "1"
  asg_min_size                  = "1"
  asg_desired_capacity          = "1"
  asg_notification_topic_arn    = data.terraform_remote_state.infra_monitoring.sns_topic_autoscaling_group_events_arn
  root_block_device_volume_size = var.root_block_device_volume_size
}

resource "aws_ebs_volume" "ci-agent-1-data" {
  availability_zone = lookup(data.terraform_remote_state.infra_networking.private_subnet_names_azs_map, var.ci_agent_1_subnet)
  encrypted         = var.ebs_encrypted
  size              = var.data_block_device_volume_size
  type              = var.ebs_volume_type

  tags {
    Name            = "${var.stackname}-ci-agent-1-data"
    Project         = var.stackname
    Device          = "xvdf"
    aws_hostname    = "ci-agent-1"
    aws_migration   = "ci_agent"
    aws_stackname   = var.stackname
    aws_environment = var.aws_environment
  }
}

resource "aws_ebs_volume" "ci-agent-1-docker" {
  availability_zone = lookup(data.terraform_remote_state.infra_networking.private_subnet_names_azs_map, var.ci_agent_1_subnet)
  encrypted         = var.ebs_encrypted
  size              = var.docker_block_device_volume_size
  type              = var.ebs_volume_type

  tags {
    Name            = "${var.stackname}-ci-agent-1-docker"
    Project         = var.stackname
    Device          = "xvdg"
    aws_hostname    = "ci-agent-1"
    aws_migration   = "ci_agent"
    aws_stackname   = var.stackname
    aws_environment = var.aws_environment
  }
}

resource "aws_iam_role_policy_attachment" "ci-agent-1_iam_role_policy_attachment" {
  role       = module.ci-agent-1.instance_iam_role_name
  policy_arn = aws_iam_policy.ci-agent_iam_policy.arn
}

module "alarms-elb-ci-agent-1-internal" {
  source                         = "../../modules/aws/alarms/elb"
  name_prefix                    = "${var.stackname}-ci-agent-1-internal"
  alarm_actions                  = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  elb_name                       = aws_elb.ci-agent-1_elb.name
  httpcode_backend_4xx_threshold = "0"
  httpcode_backend_5xx_threshold = "50"
  httpcode_elb_4xx_threshold     = "0"
  httpcode_elb_5xx_threshold     = "50"
  surgequeuelength_threshold     = "0"
  healthyhostcount_threshold     = "0"
}

/////////////////////ci-agent-2/////////////////////////////////////////////////

resource "aws_elb" "ci-agent-2_elb" {
  name            = "${var.stackname}-ci-agent-2"
  subnets         = ["${matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.ci_agent_2_subnet))}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_ci-agent-2_elb_id}"]
  internal        = "true"

  access_logs {
    bucket        = data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id
    bucket_prefix = "elb/${var.stackname}-ci-agent-2-internal-elb"
    interval      = 60
  }

  listener {
    instance_port     = 22
    instance_protocol = "tcp"
    lb_port           = 22
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3

    target   = "TCP:22"
    interval = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = map("Name", "${var.stackname}-ci-agent-2", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "ci-agent", "Environment", var.aws_environment, "Product", "GOVUK", "Owner", "govuk-replatforming-team@digital.cabinet-office.gov.uk")
}

resource "aws_route53_record" "ci-agent-2_service_record" {
  zone_id = data.aws_route53_zone.internal.zone_id
  name    = "ci-agent-2.${var.internal_domain_name}"
  type    = "A"

  alias {
    name                   = aws_elb.ci-agent-2_elb.dns_name
    zone_id                = aws_elb.ci-agent-2_elb.zone_id
    evaluate_target_health = true
  }
}

module "ci-agent-2" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-ci-agent-2"
  default_tags                  = map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "ci_agent", "aws_hostname", "ci-agent-2", "Environment", var.aws_environment, "Product", "GOVUK", "Owner", "govuk-replatforming-team@digital.cabinet-office.gov.uk")
  instance_subnet_ids           = matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.ci_agent_2_subnet))
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_ci-agent-2_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = var.instance_type
  instance_additional_user_data = join("\n", null_resource.user_data.*.triggers.snippet)
  instance_elb_ids_length       = "1"
  instance_elb_ids              = ["${aws_elb.ci-agent-2_elb.id}"]
  instance_ami_filter_name      = var.instance_ami_filter_name
  asg_max_size                  = "1"
  asg_min_size                  = "1"
  asg_desired_capacity          = "1"
  asg_notification_topic_arn    = data.terraform_remote_state.infra_monitoring.sns_topic_autoscaling_group_events_arn
  root_block_device_volume_size = var.root_block_device_volume_size
}

resource "aws_ebs_volume" "ci-agent-2-data" {
  availability_zone = lookup(data.terraform_remote_state.infra_networking.private_subnet_names_azs_map, var.ci_agent_2_subnet)
  encrypted         = var.ebs_encrypted
  size              = var.data_block_device_volume_size
  type              = var.ebs_volume_type

  tags {
    Name            = "${var.stackname}-ci-agent-2-data"
    Project         = var.stackname
    Device          = "xvdf"
    aws_hostname    = "ci-agent-2"
    aws_migration   = "ci_agent"
    aws_stackname   = var.stackname
    aws_environment = var.aws_environment
  }
}

resource "aws_ebs_volume" "ci-agent-2-docker" {
  availability_zone = lookup(data.terraform_remote_state.infra_networking.private_subnet_names_azs_map, var.ci_agent_2_subnet)
  encrypted         = var.ebs_encrypted
  size              = var.docker_block_device_volume_size
  type              = var.ebs_volume_type

  tags {
    Name            = "${var.stackname}-ci-agent-2-docker"
    Project         = var.stackname
    Device          = "xvdg"
    aws_hostname    = "ci-agent-2"
    aws_migration   = "ci_agent"
    aws_stackname   = var.stackname
    aws_environment = var.aws_environment
  }
}

resource "aws_iam_policy" "ci-agent-2_iam_policy" {
  name   = "${var.stackname}-ci-agent-2-volume"
  path   = "/"
  policy = file("${path.module}/volume_policy.json")
}

resource "aws_iam_role_policy_attachment" "ci-agent-2_iam_role_policy_attachment" {
  role       = module.ci-agent-2.instance_iam_role_name
  policy_arn = aws_iam_policy.ci-agent_iam_policy.arn
}

module "alarms-elb-ci-agent-2-internal" {
  source                         = "../../modules/aws/alarms/elb"
  name_prefix                    = "${var.stackname}-ci-agent-2-internal"
  alarm_actions                  = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  elb_name                       = aws_elb.ci-agent-2_elb.name
  httpcode_backend_4xx_threshold = "0"
  httpcode_backend_5xx_threshold = "50"
  httpcode_elb_4xx_threshold     = "0"
  httpcode_elb_5xx_threshold     = "50"
  surgequeuelength_threshold     = "0"
  healthyhostcount_threshold     = "0"
}

/////////////////////ci-agent-3/////////////////////////////////////////////////

resource "aws_elb" "ci-agent-3_elb" {
  name            = "${var.stackname}-ci-agent-3"
  subnets         = ["${matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.ci_agent_3_subnet))}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_ci-agent-3_elb_id}"]
  internal        = "true"

  access_logs {
    bucket        = data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id
    bucket_prefix = "elb/${var.stackname}-ci-agent-3-internal-elb"
    interval      = 60
  }

  listener {
    instance_port     = 22
    instance_protocol = "tcp"
    lb_port           = 22
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3

    target   = "TCP:22"
    interval = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = "${map("Name", "${var.stackname}-ci-agent-3", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "ci-agent")}"
}

resource "aws_route53_record" "ci-agent-3_service_record" {
  zone_id = data.aws_route53_zone.internal.zone_id
  name    = "ci-agent-3.${var.internal_domain_name}"
  type    = "A"

  alias {
    name                   = aws_elb.ci-agent-3_elb.dns_name
    zone_id                = aws_elb.ci-agent-3_elb.zone_id
    evaluate_target_health = true
  }
}

module "ci-agent-3" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-ci-agent-3"
  default_tags                  = "${map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "ci_agent", "aws_hostname", "ci-agent-3")}"
  instance_subnet_ids           = matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.ci_agent_3_subnet))
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_ci-agent-3_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = var.instance_type
  instance_additional_user_data = join("\n", null_resource.user_data.*.triggers.snippet)
  instance_elb_ids_length       = "1"
  instance_elb_ids              = ["${aws_elb.ci-agent-3_elb.id}"]
  instance_ami_filter_name      = var.instance_ami_filter_name
  asg_max_size                  = "1"
  asg_min_size                  = "1"
  asg_desired_capacity          = "1"
  asg_notification_topic_arn    = data.terraform_remote_state.infra_monitoring.sns_topic_autoscaling_group_events_arn
  root_block_device_volume_size = var.root_block_device_volume_size
}

resource "aws_ebs_volume" "ci-agent-3-data" {
  availability_zone = lookup(data.terraform_remote_state.infra_networking.private_subnet_names_azs_map, var.ci_agent_3_subnet)
  encrypted         = var.ebs_encrypted
  size              = var.data_block_device_volume_size
  type              = var.ebs_volume_type

  tags {
    Name            = "${var.stackname}-ci-agent-3-data"
    Project         = var.stackname
    Device          = "xvdf"
    aws_hostname    = "ci-agent-3"
    aws_migration   = "ci_agent"
    aws_stackname   = var.stackname
    aws_environment = var.aws_environment
  }
}

resource "aws_ebs_volume" "ci-agent-3-docker" {
  availability_zone = lookup(data.terraform_remote_state.infra_networking.private_subnet_names_azs_map, var.ci_agent_3_subnet)
  encrypted         = var.ebs_encrypted
  size              = var.docker_block_device_volume_size
  type              = var.ebs_volume_type

  tags {
    Name            = "${var.stackname}-ci-agent-3-docker"
    Project         = var.stackname
    Device          = "xvdg"
    aws_hostname    = "ci-agent-3"
    aws_migration   = "ci_agent"
    aws_stackname   = var.stackname
    aws_environment = var.aws_environment
  }
}

resource "aws_iam_role_policy_attachment" "ci-agent-3_iam_role_policy_attachment" {
  role       = module.ci-agent-3.instance_iam_role_name
  policy_arn = aws_iam_policy.ci-agent_iam_policy.arn
}

module "alarms-elb-ci-agent-3-internal" {
  source                         = "../../modules/aws/alarms/elb"
  name_prefix                    = "${var.stackname}-ci-agent-3-internal"
  alarm_actions                  = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  elb_name                       = aws_elb.ci-agent-3_elb.name
  httpcode_backend_4xx_threshold = "0"
  httpcode_backend_5xx_threshold = "50"
  httpcode_elb_4xx_threshold     = "0"
  httpcode_elb_5xx_threshold     = "50"
  surgequeuelength_threshold     = "0"
  healthyhostcount_threshold     = "0"
}

/////////////////////ci-agent-4/////////////////////////////////////////////////

resource "aws_elb" "ci-agent-4_elb" {
  name            = "${var.stackname}-ci-agent-4"
  subnets         = ["${matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.ci_agent_4_subnet))}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_ci-agent-4_elb_id}"]
  internal        = "true"

  access_logs {
    bucket        = data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id
    bucket_prefix = "elb/${var.stackname}-ci-agent-4-internal-elb"
    interval      = 60
  }

  listener {
    instance_port     = 22
    instance_protocol = "tcp"
    lb_port           = 22
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3

    target   = "TCP:22"
    interval = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = map("Name", "${var.stackname}-ci-agent-4", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "ci-agent", "Environment", var.aws_environment, "Product", "GOVUK", "Owner", "govuk-replatforming-team@digital.cabinet-office.gov.uk")
}

resource "aws_route53_record" "ci-agent-4_service_record" {
  zone_id = data.aws_route53_zone.internal.zone_id
  name    = "ci-agent-4.${var.internal_domain_name}"
  type    = "A"

  alias {
    name                   = aws_elb.ci-agent-4_elb.dns_name
    zone_id                = aws_elb.ci-agent-4_elb.zone_id
    evaluate_target_health = true
  }
}

module "ci-agent-4" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-ci-agent-4"
  default_tags                  = map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "ci_agent", "aws_hostname", "ci-agent-4", "Environment", var.aws_environment, "Product", "GOVUK", "Owner", "govuk-replatforming-team@digital.cabinet-office.gov.uk")
  instance_subnet_ids           = matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.ci_agent_4_subnet))
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_ci-agent-4_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = var.instance_type
  instance_additional_user_data = join("\n", null_resource.user_data.*.triggers.snippet)
  instance_elb_ids_length       = "1"
  instance_elb_ids              = ["${aws_elb.ci-agent-4_elb.id}"]
  instance_ami_filter_name      = var.instance_ami_filter_name
  asg_max_size                  = "1"
  asg_min_size                  = "1"
  asg_desired_capacity          = "1"
  asg_notification_topic_arn    = data.terraform_remote_state.infra_monitoring.sns_topic_autoscaling_group_events_arn
  root_block_device_volume_size = var.root_block_device_volume_size
}

resource "aws_ebs_volume" "ci-agent-4-data" {
  availability_zone = lookup(data.terraform_remote_state.infra_networking.private_subnet_names_azs_map, var.ci_agent_4_subnet)
  encrypted         = var.ebs_encrypted
  size              = var.data_block_device_volume_size
  type              = var.ebs_volume_type

  tags {
    Name            = "${var.stackname}-ci-agent-4-data"
    Project         = var.stackname
    Device          = "xvdf"
    aws_hostname    = "ci-agent-4"
    aws_migration   = "ci_agent"
    aws_stackname   = var.stackname
    aws_environment = var.aws_environment
  }
}

resource "aws_ebs_volume" "ci-agent-4-docker" {
  availability_zone = lookup(data.terraform_remote_state.infra_networking.private_subnet_names_azs_map, var.ci_agent_4_subnet)
  encrypted         = var.ebs_encrypted
  size              = var.docker_block_device_volume_size
  type              = var.ebs_volume_type

  tags {
    Name            = "${var.stackname}-ci-agent-4-docker"
    Project         = var.stackname
    Device          = "xvdg"
    aws_hostname    = "ci-agent-4"
    aws_migration   = "ci_agent"
    aws_stackname   = var.stackname
    aws_environment = var.aws_environment
  }
}

resource "aws_iam_role_policy_attachment" "ci-agent-4_iam_role_policy_attachment" {
  role       = module.ci-agent-4.instance_iam_role_name
  policy_arn = aws_iam_policy.ci-agent_iam_policy.arn
}

module "alarms-elb-ci-agent-4-internal" {
  source                         = "../../modules/aws/alarms/elb"
  name_prefix                    = "${var.stackname}-ci-agent-4-internal"
  alarm_actions                  = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  elb_name                       = aws_elb.ci-agent-4_elb.name
  httpcode_backend_4xx_threshold = "0"
  httpcode_backend_5xx_threshold = "50"
  httpcode_elb_4xx_threshold     = "0"
  httpcode_elb_5xx_threshold     = "50"
  surgequeuelength_threshold     = "0"
  healthyhostcount_threshold     = "0"
}

/////////////////////ci-agent-5/////////////////////////////////////////////////

resource "aws_elb" "ci-agent-5_elb" {
  name            = "${var.stackname}-ci-agent-5"
  subnets         = ["${matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.ci_agent_5_subnet))}"]
  security_groups = ["${data.terraform_remote_state.infra_security_groups.sg_ci-agent-5_elb_id}"]
  internal        = "true"

  access_logs {
    bucket        = data.terraform_remote_state.infra_monitoring.aws_logging_bucket_id
    bucket_prefix = "elb/${var.stackname}-ci-agent-5-internal-elb"
    interval      = 60
  }

  listener {
    instance_port     = 22
    instance_protocol = "tcp"
    lb_port           = 22
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3

    target   = "TCP:22"
    interval = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = map("Name", "${var.stackname}-ci-agent-5", "Project", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "ci-agent", "Environment", var.aws_environment, "Product", "GOVUK", "Owner", "govuk-replatforming-team@digital.cabinet-office.gov.uk")
}

resource "aws_route53_record" "ci-agent-5_service_record" {
  zone_id = data.aws_route53_zone.internal.zone_id
  name    = "ci-agent-5.${var.internal_domain_name}"
  type    = "A"

  alias {
    name                   = aws_elb.ci-agent-5_elb.dns_name
    zone_id                = aws_elb.ci-agent-5_elb.zone_id
    evaluate_target_health = true
  }
}

module "ci-agent-5" {
  source                        = "../../modules/aws/node_group"
  name                          = "${var.stackname}-ci-agent-5"
  default_tags                  = map("Project", var.stackname, "aws_stackname", var.stackname, "aws_environment", var.aws_environment, "aws_migration", "ci_agent", "aws_hostname", "ci-agent-5", "Environment", var.aws_environment, "Product", "GOVUK", "Owner", "govuk-replatforming-team@digital.cabinet-office.gov.uk")
  instance_subnet_ids           = matchkeys(values(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), keys(data.terraform_remote_state.infra_networking.private_subnet_names_ids_map), list(var.ci_agent_5_subnet))
  instance_security_group_ids   = ["${data.terraform_remote_state.infra_security_groups.sg_ci-agent-5_id}", "${data.terraform_remote_state.infra_security_groups.sg_management_id}"]
  instance_type                 = var.instance_type
  instance_additional_user_data = join("\n", null_resource.user_data.*.triggers.snippet)
  instance_elb_ids_length       = "1"
  instance_elb_ids              = ["${aws_elb.ci-agent-5_elb.id}"]
  instance_ami_filter_name      = var.instance_ami_filter_name
  asg_max_size                  = "1"
  asg_min_size                  = "1"
  asg_desired_capacity          = "1"
  asg_notification_topic_arn    = data.terraform_remote_state.infra_monitoring.sns_topic_autoscaling_group_events_arn
  root_block_device_volume_size = var.root_block_device_volume_size
}

resource "aws_ebs_volume" "ci-agent-5-data" {
  availability_zone = lookup(data.terraform_remote_state.infra_networking.private_subnet_names_azs_map, var.ci_agent_5_subnet)
  encrypted         = var.ebs_encrypted
  size              = var.data_block_device_volume_size
  type              = var.ebs_volume_type

  tags {
    Name            = "${var.stackname}-ci-agent-5-data"
    Project         = var.stackname
    Device          = "xvdf"
    aws_hostname    = "ci-agent-5"
    aws_migration   = "ci_agent"
    aws_stackname   = var.stackname
    aws_environment = var.aws_environment
  }
}

resource "aws_ebs_volume" "ci-agent-5-docker" {
  availability_zone = lookup(data.terraform_remote_state.infra_networking.private_subnet_names_azs_map, var.ci_agent_5_subnet)
  encrypted         = var.ebs_encrypted
  size              = var.docker_block_device_volume_size
  type              = var.ebs_volume_type

  tags {
    Name            = "${var.stackname}-ci-agent-5-docker"
    Project         = var.stackname
    Device          = "xvdg"
    aws_hostname    = "ci-agent-5"
    aws_migration   = "ci_agent"
    aws_stackname   = var.stackname
    aws_environment = var.aws_environment
  }
}

resource "aws_iam_role_policy_attachment" "ci-agent-5_iam_role_policy_attachment" {
  role       = module.ci-agent-5.instance_iam_role_name
  policy_arn = aws_iam_policy.ci-agent_iam_policy.arn
}

module "alarms-elb-ci-agent-5-internal" {
  source                         = "../../modules/aws/alarms/elb"
  name_prefix                    = "${var.stackname}-ci-agent-5-internal"
  alarm_actions                  = ["${data.terraform_remote_state.infra_monitoring.sns_topic_cloudwatch_alarms_arn}"]
  elb_name                       = aws_elb.ci-agent-5_elb.name
  httpcode_backend_4xx_threshold = "0"
  httpcode_backend_5xx_threshold = "50"
  httpcode_elb_4xx_threshold     = "0"
  httpcode_elb_5xx_threshold     = "50"
  surgequeuelength_threshold     = "0"
  healthyhostcount_threshold     = "0"
}

# Outputs
# --------------------------------------------------------------

output "ci-agent-1_elb_dns_name" {
  value       = aws_elb.ci-agent-1_elb.dns_name
  description = "DNS name to access the CI agent 1 service"
}

output "ci-agent-1_service_dns_name" {
  value       = aws_route53_record.ci-agent-1_service_record.name
  description = "DNS name to access the CI agent 1 service"
}

output "ci-agent-2_elb_dns_name" {
  value       = aws_elb.ci-agent-2_elb.dns_name
  description = "DNS name to access the CI agent 2 service"
}

output "ci-agent-2_service_dns_name" {
  value       = aws_route53_record.ci-agent-2_service_record.name
  description = "DNS name to access the CI agent 2 service"
}

output "ci-agent-3_elb_dns_name" {
  value       = aws_elb.ci-agent-3_elb.dns_name
  description = "DNS name to access the CI agent 3 service"
}

output "ci-agent-3_service_dns_name" {
  value       = aws_route53_record.ci-agent-3_service_record.name
  description = "DNS name to access the CI agent 3 service"
}

output "ci-agent-4_elb_dns_name" {
  value       = aws_elb.ci-agent-4_elb.dns_name
  description = "DNS name to access the CI agent 4 service"
}

output "ci-agent-4_service_dns_name" {
  value       = aws_route53_record.ci-agent-4_service_record.name
  description = "DNS name to access the CI agent 4 service"
}

output "ci-agent-5_elb_dns_name" {
  value       = aws_elb.ci-agent-5_elb.dns_name
  description = "DNS name to access the CI agent 5 service"
}

output "ci-agent-5_service_dns_name" {
  value       = aws_route53_record.ci-agent-5_service_record.name
  description = "DNS name to access the CI agent 5 service"
}
