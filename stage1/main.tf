provider "aws" {
  region = "${var.aws_region}"
}

data "terraform_remote_state" "network" {
  backend = "remote"

  config = {
    token        = ""
    organization = ""
    workspaces = {
      name = "prj0-network-${terraform.workspace}"
    }
  }
}


module "security" {
  source             = "../modules/security"
  localip            = "${var.localip}"
  name_of_deploy     = data.terraform_remote_state.network.outputs.name_of_deploy
  key_name           = "${var.key_name}"
  vpc_id             = data.terraform_remote_state.network.outputs.vpc_id
  vpc_ips            = [data.terraform_remote_state.network.outputs.vpc_ips]
  key_pub_path       = "./id_rsa.pub"
}
