resource "gitlab_group" "iam" {
  name             = "iam"
  description      = "Identity & Access Management Team"
  path             = "iam"
  visibility_level = "private"
}

resource "gitlab_group_variable" "iam_minio_adm_sa_access_key" {
  group     = gitlab_group.iam.id
  key       = "MINIO_ADM_SA_ACCESS_KEY"
  value     = module.minio_sa_api_key_iam.data.username
  protected = false
  masked    = true
}

resource "gitlab_group_variable" "iam_minio_adm_sa_secret_key" {
  group     = gitlab_group.iam.id
  key       = "MINIO_ADM_SA_SECRET_KEY"
  value     = module.minio_sa_api_key_iam.data.password
  protected = false
  masked    = true
}

# Should be split to Gitlab & Spacelift
resource "gitlab_user" "iam_runner_sa" {
  name             = "IAM Runner Service Account"
  username         = module.bw_iam_gitlab_user.data.username
  password         = module.bw_iam_gitlab_user.data.password
  email            = "${module.bw_iam_gitlab_user.data.username}@mail.adm.acme.corp"
  is_admin         = false
  can_create_group = false
  is_external      = false
  reset_password   = false
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
  expires_at = "2025-01-10"
  scopes     = ["api"]
}

resource "local_sensitive_file" "iam_runner_sa_pat" {
  content  = gitlab_personal_access_token.iam_runner_sa.token
  filename = ".terraform/iam_runner_sa_pat.out"
}
