/**
* ## Module: projects/infra-carrenza-vpn
*
* Creates a VPN for AWS to connect to Carrenza
*/

variable "aws_region" {
  type        = "string"
  description = "AWS region"
  default     = "eu-west-1"
}

variable "stackname" {
  type        = "string"
  description = "Stackname"
  default     = ""
}

variable "carrenza_vpn_endpoint_ip" {
  type        = "string"
  description = "Public IP address of the VPN gateway in Carrenza"
}

variable "carrenza_internal_net_cidr" {
  type        = "string"
  description = "Internal network range of the environment in Carrenza"
}

variable "aws_tunnel1_psk" {
  type        = "string"
  description = "Explicit PSK in format required by Carrenza"
}

variable "aws_tunnel2_psk" {
  type        = "string"
  description = "Explicit PSK in format required by Carrenza"
}

variable "remote_state_bucket" {
  type        = "string"
  description = "S3 bucket we store our terraform state in"
}

variable "remote_state_infra_networking_key_stack" {
  type        = "string"
  description = "Override stackname path to infra_monitoring remote state "
  default     = ""
}

variable "remote_state_infra_vpc_key_stack" {
  type        = "string"
  description = "Override stackname path to infra_monitoring remote state "
  default     = ""
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

data "terraform_remote_state" "infra_networking" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket}"
    key    = "${coalesce(var.remote_state_infra_networking_key_stack, var.stackname)}/infra-networking.tfstate"
    region = "${var.aws_region}"
  }
}

data "terraform_remote_state" "infra_vpc" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket}"
    key    = "${coalesce(var.remote_state_infra_vpc_key_stack, var.stackname)}/infra-vpc.tfstate"
    region = "${var.aws_region}"
  }
}

resource "aws_customer_gateway" "carrenza_vpn_gateway" {
  bgp_asn    = 65000
  ip_address = "${var.carrenza_vpn_endpoint_ip}"
  type       = "ipsec.1"

  tags {
    Name = "Carrenza - ${var.stackname}"
  }
}

resource "aws_vpn_gateway" "aws_vpn_gateway" {
  vpc_id = "${data.terraform_remote_state.infra_vpc.vpc_id}"

  tags {
    Name = "${var.stackname} VPN Gateway"
  }
}

resource "aws_vpn_connection" "aws_carrenza_vpn" {
  vpn_gateway_id        = "${aws_vpn_gateway.aws_vpn_gateway.id}"
  customer_gateway_id   = "${aws_customer_gateway.carrenza_vpn_gateway.id}"
  tunnel1_preshared_key = "${var.aws_tunnel1_psk}"
  tunnel2_preshared_key = "${var.aws_tunnel2_psk}"
  type                  = "ipsec.1"
  static_routes_only    = true

  tags {
    Name = "${var.stackname} AWS to Carrenza"
  }
}

resource "aws_vpn_connection_route" "Carrenza" {
  destination_cidr_block = "${var.carrenza_internal_net_cidr}"
  vpn_connection_id      = "${aws_vpn_connection.aws_carrenza_vpn.id}"
}

resource "aws_vpn_gateway_route_propagation" "Carrenza_route_propagation" {
  count          = "${length(data.terraform_remote_state.infra_networking.private_subnet_names_route_tables_map)}"
  vpn_gateway_id = "${aws_vpn_gateway.aws_vpn_gateway.id}"
  route_table_id = "${element(values(data.terraform_remote_state.infra_networking.private_subnet_names_route_tables_map), count.index)}"
}

resource "aws_vpn_gateway_route_propagation" "Carrenza_route_propagation_reserved_ips" {
  count          = "${length(data.terraform_remote_state.infra_networking.private_subnet_reserved_ips_names_route_tables_map)}"
  vpn_gateway_id = "${aws_vpn_gateway.aws_vpn_gateway.id}"
  route_table_id = "${element(values(data.terraform_remote_state.infra_networking.private_subnet_reserved_ips_names_route_tables_map), count.index)}"
}

# Outputs
# --------------------------------------------------------------

output "aws_vpn_connection_id" {
  value       = "${aws_vpn_connection.aws_carrenza_vpn.id}"
  description = "The ID of the AWS to Carrenza VPN"
}
