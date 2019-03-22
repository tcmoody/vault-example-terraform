resource "aws_subnet" "public" {
  count = "${var.num_public_subnets}"
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${element(var.public_subnet_cidrs, count.index)}"
  map_public_ip_on_launch = true
  availability_zone = "${element(var.availability_zones, count.index)}"

  tags {
    Name = "${var.vpc_name}-public-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    Name = "${var.vpc_name}-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    Name = "${var.vpc_name}-public-route-table"
  }
}

resource "aws_route" "igw-route" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.igw.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "public" {
  count = "${var.num_public_subnets}"
  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_eip" "vpc_nat_eip" {
  count = "${var.num_public_subnets}"
  vpc = true
  depends_on = ["aws_vpc.vpc"]
}

resource "aws_nat_gateway" "nat_gateway" {
  count = "${var.num_public_subnets}"
  allocation_id = "${element(aws_eip.vpc_nat_eip.*.id, count.index)}"
  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
}

output "public_subnet_id" {
  value = "${aws_subnet.public.0.id}"
}

output "public_subnet_ids" {
  value = "${aws_subnet.public.*.id}"
}