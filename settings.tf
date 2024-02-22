terraform {
  backend "s3" {}
  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "~> 16.9"
    }
    bitwarden = {
      source  = "maxlaverse/bitwarden"
      version = "~> 0.7"
    }
  }
}
