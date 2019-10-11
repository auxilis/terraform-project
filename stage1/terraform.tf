terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = ""
    token        = ""

    workspaces {
      prefix = "prj0-security-"
    }
  }
  required_version = ">= 0.12.0"
}

