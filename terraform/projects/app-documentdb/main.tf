/**
* ## Project: app-documentdb
*
* Shared DocumentDB initially for Licensify
*/
variable "aws_environment" {
  type        = "string"
  description = "AWS environment"
}

variable "aws_region" {
  type        = "string"
  description = "AWS region"
  default     = "eu-west-1"
}

variable "stackname" {
  type        = "string"
  description = "Stackname"
}

variable "instance_type" {
  type        = "string"
  description = "Instance type used for DocumentDB resources"
  default     = "db.r5.large"
}

variable "instance_count" {
  type        = "number"
  description = "Instance count used for DocumentDB resources"
  default     = 3
}

# Resources
# --------------------------------------------------------------
terraform {
  backend          "s3"             {}
  required_version = "= 0.11.14"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "2.16.0"
}

resource "aws_docdb_cluster_instance" "cluster_instances" {
  count              = "${var.instance_count}"
  identifier         = "docdb-cluster-demo-${count.index}"
  cluster_identifier = "${aws_docdb_cluster.default.id}"
  instance_class     = "${var.instance_type}"
}

resource "aws_docdb_cluster" "cluster" {
  cluster_identifier = "docdb-cluster-${aws_environment}"
  availability_zones = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  master_username    = "${var.master_username}"
  master_password    = "${var.master_password}"
}

resource "aws_security_group" "docdb_sg" {
  name        = "documentdb_sg"
  description = "Allow access to cluster from client instances"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 443
    to_port     = 443
    protocol    = "-1"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = # add a CIDR block here
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = ["pl-12c4e678"]
  }
}

resource "aws_route53_record" "service_record" {
  zone_id = "${data.aws_route53_zone.internal.zone_id}"
  name    = "documentdb.${var.internal_domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = ["${aws_docdb_cluster.cluster.endpoint}"]
}

#security

#tagging
