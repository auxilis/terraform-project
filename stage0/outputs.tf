output "public_subnets" {
  value = "${module.network.public_subnets}"
}

output "private_subnets" {
  value = "${module.network.private_subnets}"
}

output "public_subnet_ips" {
  value = "${module.network.public_subnet_ips}"
}

output "private_subnet_ips" {
  value = "${module.network.private_subnet_ips}"
}

output "vpc_id" {
  value = "${module.network.vpc_id}"
}

output "vpc_ips" {
  value = "${module.network.vpc_ips}"
}

output "name_of_deploy" {
  value = "${module.network.name_of_deploy}"
}

output "aws_region" {
  value = "${var.aws_region}"
}

output "az_count" {
  value = "${var.az_count}"
}
