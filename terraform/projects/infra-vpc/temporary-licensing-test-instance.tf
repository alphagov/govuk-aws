variable "office_ips" {
  type = "string"
}

data "aws_ami" "jammy" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_key_pair" "this" {
  key_name   = "richard-towers-ssh-ed25519"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBznmW+hlnSqCeuYFIMSI+hRSQdngjMWWQ9HWipd33sj richard.towers@digital.cabinet-office.gov.uk"
}

resource "aws_security_group" "temp_towers_allow_ssh" {
  vpc_id      = "${module.vpc.vpc_id}"
  name_prefix = "temp_towers_allow_ssh_"
  description = "Allow SSH"

  ingress {
    cidr_blocks = ["${var.office_ips}"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "temp_towers_allow_egress" {
  vpc_id      = aws_vpc.this.id
  name_prefix = "temp_towers_allow_egress_"
  description = "Allow Egress to the entire internet"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "this" {
  ami           = "${data.aws_ami.jammy.id}"
  instance_type = "t3.nano"
  key_name      = "${aws_key_pair.this.key_name}"

  subnet_id                   = "${aws_subnet.this.id}"
  associate_public_ip_address = true
  vpc_security_group_ids = [
    "${aws_security_group.temp_towers_allow_ssh.id}",
    "${aws_security_group.temp_towers_allow_egress.id}",
  ]

  tags = {
    Name = "Temporary instance for testing licensing networking to Civica"
  }
}

resource "aws_eip_association" "this" {
  instance_id   = "${aws_instance.this.id}"
  allocation_id = "eipalloc-0c15477b55906cc2c" # staging licensify-reservation-0
}

output "public_ip" {
  value = "${aws_instance.this.public_ip}"
}

