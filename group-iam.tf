resource "gitlab_group" "iam" {
  name             = "iam"
  description      = "Identity & Access Management Team"
  path             = "iam"
  visibility_level = "private"
}

# Add only variables necessary to run the self-config repository
resource "gitlab_group_variable" "iam_minio_adm_sa_access_key" {
  group     = gitlab_group.iam.id
  key       = "MINIO_ADM_SA_ACCESS_KEY"
  value     = module.minio_sa_api_key_iam.data.username
  protected = false
  masked    = true
  raw       = true
}

resource "gitlab_group_variable" "iam_minio_adm_sa_secret_key" {
  group     = gitlab_group.iam.id
  key       = "MINIO_ADM_SA_SECRET_KEY"
  value     = module.minio_sa_api_key_iam.data.password
  protected = false
  masked    = true
  raw       = true
}

resource "gitlab_group_variable" "iam_bitwarden_master_password" {
  group     = gitlab_group.iam.id
  key       = "TF_VAR_bitwarden_master_password"
  value     = module.bw_iam_bitwarden_user.data.password
  protected = false
  masked    = true
  raw       = true
}

resource "gitlab_group_variable" "iam_bitwarden_client_id" {
  group     = gitlab_group.iam.id
  key       = "TF_VAR_bitwarden_client_id"
  value     = module.bw_iam_bitwarden_user.data.client_id
  protected = false
  masked    = true
  raw       = true
}

resource "gitlab_group_variable" "iam_bitwarden_client_secret" {
  group     = gitlab_group.iam.id
  key       = "TF_VAR_bitwarden_client_secret"
  value     = module.bw_iam_bitwarden_user.data.client_secret
  protected = false
  masked    = true
  raw       = true
}

resource "gitlab_group_variable" "iam_bitwarden_email" {
  group     = gitlab_group.iam.id
  key       = "TF_VAR_bitwarden_email"
  value     = module.bw_iam_bitwarden_user.data.username
  protected = false
  masked    = false
  raw       = true
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
  scopes     = ["api", "read_api"]
}

resource "local_sensitive_file" "iam_runner_sa_pat" {
  content  = gitlab_personal_access_token.iam_runner_sa.token
  filename = ".terraform/iam_runner_sa_pat.out"
}

resource "gitlab_project" "iam_group_self_config" {
  name                          = "iac-gitlab-group-iam"
  namespace_id                  = gitlab_group.iam.id
  visibility_level              = "private"
  builds_access_level           = "private"
  wiki_enabled                  = false
  packages_enabled              = false
  default_branch                = "main"
  merge_method                  = "merge"
  auto_cancel_pending_pipelines = "enabled"
  auto_devops_enabled           = false
}
