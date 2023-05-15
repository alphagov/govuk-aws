/**
* ## Project: app-asset-master
*
* Assets EFS (NFS) volume.
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

resource "aws_efs_file_system" "assets-efs-fs" {
  creation_token = "${var.stackname}-assets"
  tags = {
    "Name"            = "${var.stackname}-asset-master"
    "Description"     = "Asset Manager and Whitehall attachments are stored here temporarily for malware scanning before being transferred to S3."
    "Project"         = var.stackname
    "aws_environment" = var.aws_environment
    "aws_migration"   = "asset_master"
  }
}

resource "aws_efs_mount_target" "assets-mount-target" {
  count           = length(data.terraform_remote_state.infra_networking.outputs.private_subnet_ids)
  file_system_id  = aws_efs_file_system.assets-efs-fs.id
  subnet_id       = element(data.terraform_remote_state.infra_networking.outputs.private_subnet_ids, count.index)
  security_groups = [data.terraform_remote_state.infra_security_groups.outputs.sg_asset-master-efs_id]
}

resource "aws_route53_record" "assets_service_record" {
  zone_id = data.aws_route53_zone.internal.zone_id
  name    = "assets.${var.internal_domain_name}"
  type    = "CNAME"
  records = [aws_efs_mount_target.assets-mount-target.0.dns_name]
  ttl     = 300
}
