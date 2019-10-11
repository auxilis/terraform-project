provider "aws" {
  region = "${var.aws_region}"
}


module "network" {
  source         = "../modules/network"
  vpc_ips        = "${var.vpc_ips}"
  public_ips     = "${var.public_ips}"
  private_ips    = "${var.private_ips}"
  az_count       = "${var.az_count}"
  name_of_deploy = "${var.name_of_deploy}"
}
