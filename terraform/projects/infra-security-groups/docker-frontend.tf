#
# == Manifest: Project: Security Groups: docker-frontend
#
# The docker-frontend needs to be accessible on ports:
#   - 443 from the other VMs
#
# === Variables:
# stackname - string
#
# === Outputs:
# sg_docker-frontend_id
# sg_docker-frontend_elb_id

resource "aws_security_group" "docker-frontend" {
  name        = "${var.stackname}_docker-frontend_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access to the docker-frontend host from its ELB"

  tags {
    Name = "${var.stackname}_docker-frontend_access"
  }
}

# TCP port 2377 for cluster management communications
resource "aws_security_group_rule" "allow_docker-frontend_from_docker-frontend_TCP-2377" {
  type      = "ingress"
  from_port = 2377
  to_port   = 2377
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.docker-frontend.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.docker-frontend.id}"
}

# TCP and UDP port 7946 for communication among nodes
resource "aws_security_group_rule" "allow_docker-frontend_from_docker-frontend_ALL-7946" {
  type      = "ingress"
  from_port = 7946
  to_port   = 7946
  protocol  = "all"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.docker-frontend.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.docker-frontend.id}"
}

# UDP port 4789 for overlay network traffic
resource "aws_security_group_rule" "allow_docker-frontend_from_docker-frontend_UDP-4789" {
  type      = "ingress"
  from_port = 4789
  to_port   = 4789
  protocol  = "udp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.docker-frontend.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.docker-frontend.id}"
}

resource "aws_security_group_rule" "allow_docker-frontend_elb_internal_in" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.docker-frontend.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.docker-frontend_elb_internal.id}"
}

resource "aws_security_group" "docker-frontend_elb_internal" {
  name        = "${var.stackname}_docker-frontend_elb_internal_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the docker-frontend ELB"

  tags {
    Name = "${var.stackname}_docker-frontend_elb_access"
  }
}

resource "aws_security_group_rule" "allow_docker-frontend_elb_external_in" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # Which security group is the rule assigned to
  security_group_id = "${aws_security_group.docker-frontend.id}"

  # Which security group can use this rule
  source_security_group_id = "${aws_security_group.docker-frontend_elb_external.id}"
}


resource "aws_security_group" "docker-frontend_elb_external" {
  name        = "${var.stackname}_docker-frontend_elb_external_access"
  vpc_id      = "${data.terraform_remote_state.infra_vpc.vpc_id}"
  description = "Access the docker-frontend external ELB"

  tags {
    Name = "${var.stackname}_docker-frontend_elb_external_access"
  }
}

# TODO: most application instances need to talk to docker-frontend - we could
# split out some security for application and service instances?
resource "aws_security_group_rule" "allow_management_to_docker-frontend_elb_internal_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.docker-frontend_elb_internal.id}"
  source_security_group_id = "${aws_security_group.management.id}"
}

# Allow office IPs in for access to portainer
resource "aws_security_group_rule" "allow_office-ips_to_docker-frontend_elb_external_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  security_group_id        = "${aws_security_group.docker-frontend_elb_external.id}"
  cidr_blocks              = ["${var.office_ips}"]
}

# TODO test whether egress rules are needed on ELBs
resource "aws_security_group_rule" "allow_docker-frontend_elb_internal_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.docker-frontend_elb_internal.id}"
}

# TODO test whether egress rules are needed on ELBs
resource "aws_security_group_rule" "allow_docker-frontend_elb_external_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.docker-frontend_elb_external.id}"
}
