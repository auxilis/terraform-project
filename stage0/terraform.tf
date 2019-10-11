terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = ""
    token        = ""

    workspaces {
      prefix = "prj0-network-"
    }
  }
  required_version = ">= 0.12.0"
}
