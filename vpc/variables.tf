variable "vpc_name" {}
variable "vpc_cidr" {}
variable "availability_zone" {}
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