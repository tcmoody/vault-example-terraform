resource "aws_key_pair" "vault_provision_key" {
  key_name   = "${var.vault_key_name}"
  public_key = "${var.vault_provision_key}"
}

resource "aws_instance" "vault-servers" {
    count = "${var.num_vault_servers}"
    ami = "${var.ami_id}"
    instance_type = "t2.micro"
    key_name = "${aws_key_pair.vault_provision_key.key_name}"
    subnet_id = "${element(var.private_subnet_ids, count.index)}"
    iam_instance_profile = "${aws_iam_instance_profile.ec2_describe_instances_and_kms_profile.id}"
    tags = {
        Name = "vault-server-${count.index}"
        Consul_Join = "vault"
        Consul_Agent = "true"
    }
    vpc_security_group_ids = ["${var.ssh_in_id}", "${var.tcp_and_udp_outbound_all_id}",
        "${var.consul_server_inbound}", "${var.vault_inbound_from_elb_id}", "${var.vault_inbound_from_vault_id}"]
}