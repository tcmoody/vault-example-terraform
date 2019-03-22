resource "aws_security_group" "tcp-and-udp-outbound-all" {
  name = "${var.vpc_name}-outbound-all"
  description = "Allow all outbound tcp traffic"
  vpc_id = "${var.vpc_id}"

  egress {
    from_port       = 0
    to_port         = 65535
    protocol        = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 65535
    protocol        = "UDP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "tcp-outbound-all" {
  name = "${var.vpc_name}-tcp-outbound-all"
  description = "Allow all outbound tcp traffic"
  vpc_id = "${var.vpc_id}"
  egress {
    from_port       = 0
    to_port         = 65535
    protocol        = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "udp-outbound-all" {
  name = "${var.vpc_name}-udp-outbound-all"
  description = "Allow all outbound udp traffic"
  vpc_id = "${var.vpc_id}"
  egress {
    from_port       = 0
    to_port         = 65535
    protocol        = "UDP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ssh-in" {
  name = "${var.vpc_name}-ssh-in"
  description = "Allow for ssh for remote login"
  vpc_id = "${var.vpc_id}"
  ingress {
    from_port       = "22"
    to_port         = "22"
    protocol        = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "bastion-remote-login-in" {
  name = "${var.vpc_name}-bastion-remote-login-in"
  description = "Allow inbound traffic for remote login"
  vpc_id = "${var.vpc_id}"
  ingress {
    from_port       = "22"
    to_port         = "22"
    protocol        = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "consul-cluster-inbound" {
  name = "${var.vpc_name}-consul-cluster-inbound"
  description = "Allow inbound traffic to consul server from cluster"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = "8300"
    to_port = "8302"
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = "8301"
    to_port = "8302"
    protocol = "UDP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = "8500"
    to_port = "8500"
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = "8600"
    to_port = "8600"
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = "8600"
    to_port = "8600"
    protocol = "UDP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "elb-inbound-https" {
  name        = "${var.vpc_name}-elb-inbound-https"
  description = "Allow http inbound traffic from anywhere to elb"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "vault-inbound-from-elb" {
  name        = "${var.vpc_name}-vault-inbound-from-elb"
  description = "Allow http inbound traffic from elb to vault"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 8200
    to_port     = 8200
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "vault-inbound-from-vault" {
  name = "${var.vpc_name}-vault-inbound-from-vault"
  description = "Allow http traffic from other vault instances"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 8201
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// outputs
output "tcp_and_udp_outbound_all_id" {
  value = "${aws_security_group.tcp-and-udp-outbound-all.id}"
}

output "tcp_outbound_all_id" {
  value = "${aws_security_group.tcp-outbound-all.id}"
}

output "udp_outbound_all_id" {
  value = "${aws_security_group.udp-outbound-all.id}"
}

output "ssh_in_id" {
  value = "${aws_security_group.ssh-in.id}"
}

output "bastion_remote_login_in_id" {
  value = "${aws_security_group.bastion-remote-login-in.id}"
}

output "consul_cluster_inbound" {
  value = "${aws_security_group.consul-cluster-inbound.id}"
}

output "elb_inbound_https_id" {
  value = "${aws_security_group.elb-inbound-https.id}"
}

output "vault_inbound_from_elb_id" {
  value = "${aws_security_group.vault-inbound-from-elb.id}"
}

output "vault_inbound_from_vault_id" {
  value = "${aws_security_group.vault-inbound-from-vault.id}"
}