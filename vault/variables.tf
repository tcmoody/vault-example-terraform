variable "public_subnet_ids" {
    type = "list"
}
variable "private_subnet_ids" {
    type = "list"
}
variable "ami_id" {}
variable "vault_key_name" {}
variable "vault_provision_key" {}
variable "ssh_in_id" {}
variable "num_vault_servers" {}
variable "consul_server_inbound" {}
variable "elb_inbound_https_id" {}
variable "tcp_and_udp_outbound_all_id" {}
variable "tcp_outbound_all_id" {}
variable "vault_inbound_from_elb_id" {}
variable "vault_inbound_from_vault_id" {}
variable "availability_zones" {
    type = "list"
}
variable ssl_certificate_id {}
variable hosted_zone {}