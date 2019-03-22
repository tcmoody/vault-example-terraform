provider "aws" {
    region = "${var.region}"
    profile = "${var.profile}"
}

module "vpc" {
    source = "./vpc"
    vpc_name = "${var.vpc_name}"
    availability_zone = "${var.availability_zone}"
    vpc_cidr = "${var.vpc_cidr}"
    public_subnet_cidrs = "${var.public_subnet_cidrs}"
    private_subnet_cidrs = "${var.private_subnet_cidrs}"
    num_public_subnets = "${var.num_public_subnets}"
    num_private_subnets = "${var.num_private_subnets}"
    availability_zones = "${var.availability_zones}"
}

module "security_groups" {
    source = "./security_groups"
    vpc_name = "${var.vpc_name}"
    vpc_id = "${module.vpc.vpc_id}"
    private_subnet_cidrs = "${module.vpc.private_subnet_cidrs}"
}

module "bastion" {
    source = "./bastion"
    bastion_key_name = "${var.vault_vpc_key_name}"
    bastion_provision_key = "${var.vault_vpc_provision_key}"
    vpc_name = "${var.vpc_name}"
    ami_id = "${var.ami_id}"
    outbound_all_id = "${module.security_groups.tcp_outbound_all_id}"
    bastion_remote_login_in_id = "${module.security_groups.bastion_remote_login_in_id}"
    public_subnet_id = "${module.vpc.public_subnet_id}"
}

module "consul" {
    source = "./consul"
    subnet_ids = "${module.vpc.private_subnet_ids}"
    ami_id = "${var.ami_id}"
    consul_key_name = "${var.consul_key_name}"
    consul_provision_key = "${var.consul_provision_key}"
    ssh_in_id = "${module.security_groups.ssh_in_id}"
    tcp_and_udp_outbound_all_id = "${module.security_groups.tcp_and_udp_outbound_all_id}"
    consul_server_inbound = "${module.security_groups.consul_cluster_inbound}"
    num_consul_servers = "${var.num_consul_servers}"
}

module "vault" {
    source = "./vault"
    public_subnet_ids = "${module.vpc.public_subnet_ids}"
    private_subnet_ids = "${module.vpc.private_subnet_ids}"
    ami_id = "${var.ami_id}"
    vault_key_name = "${var.vault_key_name}"
    vault_provision_key = "${var.vault_provision_key}"
    ssh_in_id = "${module.security_groups.ssh_in_id}"
    tcp_and_udp_outbound_all_id = "${module.security_groups.tcp_and_udp_outbound_all_id}"
    tcp_outbound_all_id = "${module.security_groups.tcp_outbound_all_id}"
    consul_server_inbound = "${module.security_groups.consul_cluster_inbound}"
    elb_inbound_https_id = "${module.security_groups.elb_inbound_https_id}"
    vault_inbound_from_elb_id = "${module.security_groups.vault_inbound_from_elb_id}"
    vault_inbound_from_vault_id = "${module.security_groups.vault_inbound_from_vault_id}"
    availability_zones = "${var.availability_zones}"
    ssl_certificate_id = "${module.dns.vault_certificate_arn}"
    hosted_zone = "${var.hosted_zone}"
    num_vault_servers = "${var.num_vault_servers}"
}

module "kms" {
    source = "./kms"
}

module "dns" {
    source = "./dns"
    hosted_zone = "${var.hosted_zone}"
}