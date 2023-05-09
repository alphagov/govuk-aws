/**
* ## Project: app-router-backend
*
* Router backend hosts both Mongo and router-api
*/

terraform {
  backend "s3" {}
}

provider "aws" {
  region  = var.aws_region
  version = "2.46.0"
}

data "aws_route53_zone" "internal" {
  name         = var.internal_zone_name
  private_zone = true
}

locals {
  default_tags = {
    "Project"         = var.stackname
    "aws_stackname"   = var.stackname
    "aws_environment" = var.aws_environment
    "aws_migration"   = "router_backend"
  }
}

# Instance 1
resource "aws_network_interface" "router-backend-1_eni" {
  subnet_id = lookup(
    data.terraform_remote_state.infra_networking.outputs.private_subnet_reserved_ips_names_ids_map,
    var.router-backend_1_reserved_ips_subnet
  )
  private_ips     = [var.router-backend_1_ip]
  security_groups = [data.terraform_remote_state.infra_security_groups.outputs.sg_router-backend_id]

  tags = merge(local.default_tags, {
    Name         = "${var.stackname}-router-backend-1"
    aws_hostname = "router-backend-1"
  })
}

resource "aws_route53_record" "router-backend_1_service_record" {
  zone_id = data.aws_route53_zone.internal.zone_id
  name    = "router-backend-1.${var.internal_domain_name}"
  type    = "A"
  records = [var.router-backend_1_ip]
  ttl     = 300
}

module "router-backend-1" {
  source = "../../modules/aws/node_group"
  name   = "${var.stackname}-router-backend-1"
  default_tags = merge(local.default_tags, {
    "aws_hostname" = "router-backend-1"
  })
  instance_subnet_ids = matchkeys(
    values(data.terraform_remote_state.infra_networking.outputs.private_subnet_names_ids_map),
    keys(data.terraform_remote_state.infra_networking.outputs.private_subnet_names_ids_map),
    [var.router-backend_1_subnet]
  )
  instance_security_group_ids = [
    data.terraform_remote_state.infra_security_groups.outputs.sg_router-backend_id,
    data.terraform_remote_state.infra_security_groups.outputs.sg_management_id
  ]
  instance_type                 = var.instance_type
  instance_additional_user_data = join("\n", null_resource.user_data[*].triggers.snippet)
  instance_ami_filter_name      = var.instance_ami_filter_name
  asg_notification_topic_arn    = data.terraform_remote_state.infra_monitoring.outputs.sns_topic_autoscaling_group_events_arn
  root_block_device_volume_size = 20
}

# Instance 2
resource "aws_network_interface" "router-backend-2_eni" {
  subnet_id = lookup(
    data.terraform_remote_state.infra_networking.outputs.private_subnet_reserved_ips_names_ids_map,
    var.router-backend_2_reserved_ips_subnet
  )
  private_ips     = [var.router-backend_2_ip]
  security_groups = [data.terraform_remote_state.infra_security_groups.outputs.sg_router-backend_id]

  tags = merge(local.default_tags, {
    Name         = "${var.stackname}-router-backend-2"
    aws_hostname = "router-backend-2"
  })
}

resource "aws_route53_record" "router-backend_2_service_record" {
  zone_id = data.aws_route53_zone.internal.zone_id
  name    = "router-backend-2.${var.internal_domain_name}"
  type    = "A"
  records = [var.router-backend_2_ip]
  ttl     = 300
}

module "router-backend-2" {
  source = "../../modules/aws/node_group"
  name   = "${var.stackname}-router-backend-2"
  default_tags = merge(local.default_tags, {
    "aws_hostname" = "router-backend-2"
  })
  instance_subnet_ids = matchkeys(
    values(data.terraform_remote_state.infra_networking.outputs.private_subnet_names_ids_map),
    keys(data.terraform_remote_state.infra_networking.outputs.private_subnet_names_ids_map),
    [var.router-backend_2_subnet]
  )
  instance_security_group_ids = [
    data.terraform_remote_state.infra_security_groups.outputs.sg_router-backend_id,
    data.terraform_remote_state.infra_security_groups.outputs.sg_management_id
  ]
  instance_type                 = var.instance_type
  instance_additional_user_data = join("\n", null_resource.user_data[*].triggers.snippet)
  instance_ami_filter_name      = var.instance_ami_filter_name
  asg_notification_topic_arn    = data.terraform_remote_state.infra_monitoring.outputs.sns_topic_autoscaling_group_events_arn
  root_block_device_volume_size = 20
}

# Instance 3
resource "aws_network_interface" "router-backend-3_eni" {
  subnet_id = lookup(
    data.terraform_remote_state.infra_networking.outputs.private_subnet_reserved_ips_names_ids_map,
    var.router-backend_3_reserved_ips_subnet
  )
  private_ips     = [var.router-backend_3_ip]
  security_groups = [data.terraform_remote_state.infra_security_groups.outputs.sg_router-backend_id]

  tags = merge(local.default_tags, {
    Name         = "${var.stackname}-router-backend-3"
    aws_hostname = "router-backend-3"
  })
}

resource "aws_route53_record" "router-backend_3_service_record" {
  zone_id = data.aws_route53_zone.internal.zone_id
  name    = "router-backend-3.${var.internal_domain_name}"
  type    = "A"
  records = [var.router-backend_3_ip]
  ttl     = 300
}

module "router-backend-3" {
  source = "../../modules/aws/node_group"
  name   = "${var.stackname}-router-backend-3"
  default_tags = merge(local.default_tags, {
    "aws_hostname" = "router-backend-3"
  })
  instance_subnet_ids = matchkeys(
    values(data.terraform_remote_state.infra_networking.outputs.private_subnet_names_ids_map),
    keys(data.terraform_remote_state.infra_networking.outputs.private_subnet_names_ids_map),
    [var.router-backend_3_subnet]
  )
  instance_security_group_ids = [
    data.terraform_remote_state.infra_security_groups.outputs.sg_router-backend_id,
    data.terraform_remote_state.infra_security_groups.outputs.sg_management_id
  ]
  instance_type                 = var.instance_type
  instance_additional_user_data = join("\n", null_resource.user_data[*].triggers.snippet)
  instance_ami_filter_name      = var.instance_ami_filter_name
  asg_notification_topic_arn    = data.terraform_remote_state.infra_monitoring.outputs.sns_topic_autoscaling_group_events_arn
  root_block_device_volume_size = 20
}

data "terraform_remote_state" "infra_database_backups_bucket" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket
    key    = "${coalesce(var.remote_state_infra_database_backups_bucket_key_stack, var.stackname)}/infra-database-backups-bucket.tfstate"
    region = var.aws_region
  }
}

resource "aws_iam_role_policy_attachment" "write_router-backend_database_backups_iam_role_policy_attachment" {
  count = 3
  role = [
    module.router-backend-1.instance_iam_role_name,
    module.router-backend-2.instance_iam_role_name,
    module.router-backend-3.instance_iam_role_name,
  ][count.index]
  policy_arn = data.terraform_remote_state.infra_database_backups_bucket.outputs.mongo_router_write_database_backups_bucket_policy_arn
}

resource "aws_iam_role_policy_attachment" "read_integration_router-backend_database_backups_iam_role_policy_attachment" {
  count = var.aws_environment == "integration" ? 3 : 0
  role = [
    module.router-backend-1.instance_iam_role_name,
    module.router-backend-2.instance_iam_role_name,
    module.router-backend-3.instance_iam_role_name,
  ][count.index]
  policy_arn = data.terraform_remote_state.infra_database_backups_bucket.outputs.integration_mongo_router_read_database_backups_bucket_policy_arn
}

resource "aws_iam_role_policy_attachment" "read_staging_router-backend_database_backups_iam_role_policy_attachment" {
  count = var.aws_environment == "staging" ? 3 : 0
  role = [
    module.router-backend-1.instance_iam_role_name,
    module.router-backend-2.instance_iam_role_name,
    module.router-backend-3.instance_iam_role_name,
  ][count.index]
  policy_arn = data.terraform_remote_state.infra_database_backups_bucket.outputs.staging_mongo_router_read_database_backups_bucket_policy_arn
}

resource "aws_iam_role_policy_attachment" "staging_read_production_router-backend_database_backups_iam_role_policy_attachment" {
  count = var.aws_environment == "staging" ? 3 : 0
  role = [
    module.router-backend-1.instance_iam_role_name,
    module.router-backend-2.instance_iam_role_name,
    module.router-backend-3.instance_iam_role_name,
  ][count.index]
  policy_arn = data.terraform_remote_state.infra_database_backups_bucket.outputs.production_mongo_router_read_database_backups_bucket_policy_arn
}

resource "aws_iam_policy" "router-backend_iam_policy" {
  name   = "${var.stackname}-router-backend-additional"
  path   = "/"
  policy = file("${path.module}/additional_policy.json")
}

resource "aws_iam_role_policy_attachment" "router-backend_iam_role_policy_attachment" {
  count = 3
  role = [
    module.router-backend-1.instance_iam_role_name,
    module.router-backend-2.instance_iam_role_name,
    module.router-backend-3.instance_iam_role_name,
  ][count.index]
  policy_arn = aws_iam_policy.router-backend_iam_policy.arn
}
