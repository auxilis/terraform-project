terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "test_org_wk"
    token        = "e7djgqdlQ2WXjQ.atlasv1.q6qdNaCThwjIRYoTkWlR6VVHDaZjs7W0PoN2NDtb3QDe5ZJauWBsAX8iD1R4Ee5izaI"

    workspaces {
      prefix = "prj-net-"
    }
  }
}
