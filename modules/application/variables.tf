variable "public_subnets" {
  type = "list"
}
variable "name_of_deploy" {}
variable "lb_sg" {}
variable "lb_healthy_threshold" {}
variable "lb_unhealthy_threshold" {}
variable "lb_timeout" {}
variable "lb_interval" {}
variable "instance_type" {}
variable "sg_prv" {}
variable "key_id" {}
variable "asg_max" {}
variable "asg_min" {}
variable "asg_grace" {}
variable "asg_hct" {}
variable "asg_cap" {}
variable "private_subnets" {
  type = "list"
}
variable "sg_bastion" {}
variable "instance_count" {}
variable "vpc_id" {}
