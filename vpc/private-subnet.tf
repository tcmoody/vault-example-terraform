resource "aws_subnet" "private" {
  count = "${var.num_private_subnets}"
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${element(var.private_subnet_cidrs, count.index)}"
  availability_zone = "${element(var.availability_zones, count.index)}"
  tags {
    Name = "${var.vpc_name}-private-subnet"
  }
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    Name = "${var.vpc_name}-private-route-table"
  }
}

resource "aws_route" "nat-route" {
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.nat_gateway.0.id}"
  route_table_id = "${aws_route_table.private.id}"
}

resource "aws_route_table_association" "private" {
  count = "${var.num_private_subnets}"
  subnet_id = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
}

// outputs
output "private_subnet_ids" {
  value = "${aws_subnet.private.*.id}"
}

output "private_subnet_cidrs" {
  value = "${aws_subnet.private.*.cidr_block}"
}