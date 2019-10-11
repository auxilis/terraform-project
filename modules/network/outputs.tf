output "public_subnets" {
  value = "${aws_subnet.project_public_subnet.*.id}"
}

output "private_subnets" {
  value = "${aws_subnet.project_private_subnet.*.id}"
}

output "public_subnet_ips" {
  value = "${aws_subnet.project_public_subnet.*.cidr_block}"
}

output "private_subnet_ips" {
  value = "${aws_subnet.project_private_subnet.*.cidr_block}"
}

output "vpc_id" {
  value = "${aws_vpc.project_vpc.id}"
}

output "vpc_ips" {
  value = "${aws_vpc.project_vpc.cidr_block}"
}

output "name_of_deploy" {
  value = "${var.name_of_deploy}"
}
