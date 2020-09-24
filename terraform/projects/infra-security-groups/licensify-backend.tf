#
# == Manifest: Project: Security Groups: licensify-backend
#
# The licensify-backend needs to be accessible on ports:
#   - 443 from the other VMs
#
# === Outputs:
# sg_licensify-backend_id
# sg_licensify-backend_elb_id

resource "aws_security_group" "licensify-backend" {
  name        = "licensify-backend_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the licensify-backend host from its ELB"

  tags {
    Name = "licensify-backend_access"
  }
}

resource "aws_security_group_rule" "licensify-backend_ingress_licensify-backend-internal-elb_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.licensify-backend.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.licensify-backend_internal_elb.id}"
}

resource "aws_security_group_rule" "licensify-backend_ingress_licensify-backend-external-elb_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.licensify-backend.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.licensify-backend_external_elb.id}"
}

resource "aws_security_group" "licensify-backend_internal_elb" {
  name        = "licensify-backend_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the licensify-backend ELB"

  tags {
    Name = "licensify-backend_internal_elb_access"
  }
}

resource "aws_security_group_rule" "licensify-backend-internal-elb_ingress_management_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.licensify-backend_internal_elb.id}"
  source_security_group_id = "${aws_security_group.management.id}"
}

resource "aws_security_group_rule" "licensify-backend-internal-elb_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.licensify-backend_internal_elb.id}"
}

resource "aws_security_group" "licensify-backend_external_elb" {
  name        = "licensify-backend_external_elb_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the licensify-backend external ELB"

  tags {
    Name = "licensify-backend_external_elb_access"
  }
}

resource "aws_security_group_rule" "licensify-backend-external-elb_ingress_public_https" {
  type              = "ingress"
  to_port           = 443
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.licensify-backend_external_elb.id}"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Allow the public LB to serve HTTP->HTTPS redirects. See
# licensify_backend_http_80 in ../infra-public-services/main.tf.
resource "aws_security_group_rule" "licensify-backend-external-elb_ingress_public_http" {
  type              = "ingress"
  to_port           = 80
  from_port         = 80
  protocol          = "tcp"
  security_group_id = "${aws_security_group.licensify-backend_external_elb.id}"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "licensify-backend-external-elb_egress_any_any" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.licensify-backend_external_elb.id}"
}

resource "aws_security_group" "licensify_backend_ithc_access" {
  count       = "${length(var.ithc_access_ips) > 0 ? 1 : 0}"
  name        = "${var.stackname}_licensify_backend_ithc_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Control access to ITHC SSH"

  tags {
    Name = "${var.stackname}_licensify_backend_ithc_access"
  }
}

resource "aws_security_group_rule" "ithc_ingress_licensify_backend_ssh" {
  count             = "${length(var.ithc_access_ips) > 0 ? 1 : 0}"
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  cidr_blocks       = "${var.ithc_access_ips}"
  security_group_id = "${aws_security_group.licensify_backend_ithc_access.id}"
}
