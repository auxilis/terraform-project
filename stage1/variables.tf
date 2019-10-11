variable "vpc_ips" {}
variable "vpc_id" {}
variable "public_ips" {
  type = "list"
}
variable "private_ips" {
  type = "list"
}

variable "localip" {
}

variable "aws_region" {
  default = "us-east-1"
}

variable "key_name" {
}

