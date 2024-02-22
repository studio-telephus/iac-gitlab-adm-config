
# Should be split to Gitlab & Spacelift
resource "gitlab_user" "iam_runner_sa" {
  name             = "IAM Runner Service Account"
  username         = module.bw_gitlab_user_iam_runner_sa.data.username
  password         = module.bw_gitlab_user_iam_runner_sa.data.password
  email            = "${module.bw_gitlab_user_iam_runner_sa.data.username}@mail.adm.acme.corp"
  is_admin         = false
  can_create_group = false
  is_external      = false
  reset_password   = false
  projects_limit   = 1000
}

resource "gitlab_group_membership" "iam_iam_runner_sa" {
  group_id     = gitlab_group.iam.id
  user_id      = gitlab_user.iam_runner_sa.id
  access_level = "maintainer"
}

resource "gitlab_group_membership" "terraform_iam_runner_sa" {
  group_id     = gitlab_group.terraform.id
  user_id      = gitlab_user.iam_runner_sa.id
  access_level = "reporter"
}

resource "gitlab_personal_access_token" "iam_runner_sa" {
  user_id    = gitlab_user.iam_runner_sa.id
  name       = "GitLab & Spacelift"
  expires_at = "2025-02-10"
  scopes     = ["api", "read_api", "read_repository", "write_repository"]
}

module "iam_runner_sa_pat" {
  source   = "github.com/studio-telephus/terraform-bitwarden-create-item-login.git?ref=1.0.0"
  name     = "iam_gitlab_api_key"
  username = module.bw_gitlab_user_iam_runner_sa.data.username
  password = gitlab_personal_access_token.iam_runner_sa.token
}

resource "local_sensitive_file" "iam_runner_sa_pat_id" {
  content  = module.iam_runner_sa_pat.id
  filename = ".terraform/iam_runner_sa_pat_id.out"
}
