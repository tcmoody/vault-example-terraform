resource "aws_key_pair" "consul_provision_key" {
  key_name   = "${var.consul_key_name}"
  public_key = "${var.consul_provision_key}"
}

resource "aws_instance" "consul-servers" {
    count = "${var.num_consul_servers}"
    ami = "${var.ami_id}"
    instance_type = "t2.micro"
    key_name = "${aws_key_pair.consul_provision_key.key_name}"
    subnet_id = "${element(var.subnet_ids, count.index)}"
    iam_instance_profile = "${aws_iam_instance_profile.ec2_describe_instances_profile.id}"
    tags = {
        Name = "consul-server-${count.index}"
        Consul_Join = "vault"
        Consul_Server = "true"
    }
    vpc_security_group_ids = ["${var.ssh_in_id}", "${var.tcp_and_udp_outbound_all_id}", "${var.consul_server_inbound}"]
}