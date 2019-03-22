resource "aws_key_pair" "bastion_provision_key" {
  key_name   = "${var.bastion_key_name}"
  public_key = "${var.bastion_provision_key}"
}

resource "aws_instance" "bastion" {
  ami = "ami-01e3b8c3a51e88954"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.bastion_provision_key.key_name}"

  subnet_id = "${var.public_subnet_id}"
  vpc_security_group_ids = [
    "${var.bastion_remote_login_in_id}",
    "${var.outbound_all_id}"
  ]

  tags {
    Name = "${var.vpc_name}-bastion"
  }
}