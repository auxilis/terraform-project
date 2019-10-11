provider "aws" {
  region = "${var.aws_region}"
}

data "terraform_remote_state" "network" {
  backend = "remote"

  config = {
    token        = "e7djgqdlQ2WXjQ.atlasv1.q6qdNaCThwjIRYoTkWlR6VVHDaZjs7W0PoN2NDtb3QDe5ZJauWBsAX8iD1R4Ee5izaI"
    organization = "test_org_wk"
    workspaces = {
      name = "prj0-network-${terraform.workspace}"
    }
  }
}

data "terraform_remote_state" "security" {
  backend = "remote"

  config = {
    token        = "e7djgqdlQ2WXjQ.atlasv1.q6qdNaCThwjIRYoTkWlR6VVHDaZjs7W0PoN2NDtb3QDe5ZJauWBsAX8iD1R4Ee5izaI"
    organization = "test_org_wk"
    workspaces = {
      name = "prj0-security-${terraform.workspace}"
    }
  }
}


module "application" {
  vpc_id                 = data.terraform_remote_state.network.outputs.vpc_id
  source                 = "../modules/application"
  public_subnets         = data.terraform_remote_state.network.outputs.public_subnets
  private_subnets        = data.terraform_remote_state.network.outputs.private_subnets
  name_of_deploy         = data.terraform_remote_state.network.outputs.name_of_deploy
  instance_type          = "${var.instance_type}"
  lb_sg                  = [data.terraform_remote_state.security.outputs.sg_lb]
  lb_healthy_threshold   = "${var.lb_healthy_threshold}"
  lb_unhealthy_threshold = "${var.lb_unhealthy_threshold}"
  lb_timeout             = "${var.lb_timeout}"
  lb_interval            = "${var.lb_interval}"
  sg_prv                 = [data.terraform_remote_state.security.outputs.sg_priv]
  sg_bastion             = [data.terraform_remote_state.security.outputs.sg_bastion]
  asg_max                = "${var.asg_max}"
  asg_min                = "${var.asg_min}"
  asg_grace              = "${var.asg_grace}"
  asg_hct                = "${var.asg_hct}"
  asg_cap                = "${var.asg_cap}"
  key_id                 = data.terraform_remote_state.security.outputs.key_id
  #  instance_count         = data.terraform_remote_state.network.az_count
  instance_count = data.terraform_remote_state.network.outputs.az_count
}

