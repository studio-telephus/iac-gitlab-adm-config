resource "gitlab_user" "platform_runner_sa" {
  name             = "Platform Runner Service Account"
  username         = module.bw_gitlab_user_platform_runner_sa.data.username
  password         = module.bw_gitlab_user_platform_runner_sa.data.password
  email            = "${module.bw_gitlab_user_platform_runner_sa.data.username}@mail.adm.acme.corp"
  is_admin         = false
  can_create_group = false
  is_external      = false
  reset_password   = false
  projects_limit   = 1000
}

resource "gitlab_group_membership" "platform_platform_runner_sa" {
  group_id     = gitlab_group.platform.id
  user_id      = gitlab_user.platform_runner_sa.id
  access_level = "maintainer"
}

resource "gitlab_group_membership" "iam_platform_runner_sa" {
  group_id     = gitlab_group.iam.id
  user_id      = gitlab_user.platform_runner_sa.id
  access_level = "reporter"
}

resource "gitlab_group_membership" "terraform_platform_runner_sa" {
  group_id     = gitlab_group.terraform.id
  user_id      = gitlab_user.platform_runner_sa.id
  access_level = "reporter"
}

resource "gitlab_personal_access_token" "platform_runner_sa" {
  user_id    = gitlab_user.platform_runner_sa.id
  name       = "GitLab"
  expires_at = "2025-02-10"
  scopes     = ["api", "read_api"]
}

module "platform_runner_sa_pat" {
  source   = "github.com/studio-telephus/terraform-bitwarden-create-item-login.git?ref=1.0.0"
  name     = "platform_gitlab_api_key"
  username = module.bw_gitlab_user_platform_runner_sa.data.username
  password = gitlab_personal_access_token.platform_runner_sa.token
}

resource "local_sensitive_file" "platform_runner_sa_pat_id" {
  content  = module.platform_runner_sa_pat.id
  filename = ".terraform/platform_runner_sa_pat_id.out"
}
