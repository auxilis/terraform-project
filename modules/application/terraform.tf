terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "test_org_wk"
    token        = ""

    workspaces {
      prefix = "prj-app-"
    }
  }
}

