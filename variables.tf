variable "region" {}
variable "profile" {}
variable "availability_zone" {}
variable "vpc_name" {}

variable "vault_vpc_key_name" {}
variable "vault_vpc_provision_key" {}
variable "consul_key_name" {}
variable "consul_provision_key" {}
variable "vault_key_name" {}
variable "vault_provision_key" {}

variable "vpc_cidr" {}
variable "ami_id" {}
variable "hosted_zone" {}

variable "num_public_subnets" {}
variable "num_private_subnets" {}
variable "availability_zones" {
    type = "list"
}
variable "public_subnet_cidrs" {
    type = "list"
}
variable "private_subnet_cidrs" {
    type = "list"
}

variable "num_consul_servers" {}
variable "num_vault_servers" {}