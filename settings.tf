terraform {
  backend "s3" {}
  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "~> 16.7"
    }
    bitwarden = {
      source  = "maxlaverse/bitwarden"
      version = "~> 0.7"
    }
  }
}
