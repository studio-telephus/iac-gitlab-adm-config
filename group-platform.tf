resource "gitlab_group" "platform" {
  name             = "platform"
  description      = "Platform Team"
  path             = "platform"
  visibility_level = "private"
}

resource "gitlab_group_variable" "platform_minio_adm_sa_access_key" {
  group     = gitlab_group.platform.id
  key       = "MINIO_ADM_SA_ACCESS_KEY"
  value     = module.minio_sa_api_key_platform.data.username
  protected = false
  masked    = true
}

resource "gitlab_group_variable" "platform_minio_adm_sa_secret_key" {
  group     = gitlab_group.platform.id
  key       = "MINIO_ADM_SA_SECRET_KEY"
  value     = module.minio_sa_api_key_platform.data.password
  protected = false
  masked    = true
}

resource "gitlab_group_variable" "platform_bitwarden_master_password" {
  group     = gitlab_group.platform.id
  key       = "TF_VAR_bitwarden_master_password"
  value     = module.bw_platform_bitwarden_user.data.password
  protected = false
  masked    = true
  raw       = true
}

resource "gitlab_group_variable" "platform_bitwarden_client_id" {
  group     = gitlab_group.platform.id
  key       = "TF_VAR_bitwarden_client_id"
  value     = module.bw_platform_bitwarden_user.data.client_id
  protected = false
  masked    = true
  raw       = true
}

resource "gitlab_group_variable" "platform_bitwarden_client_secret" {
  group     = gitlab_group.platform.id
  key       = "TF_VAR_bitwarden_client_secret"
  value     = module.bw_platform_bitwarden_user.data.client_secret
  protected = false
  masked    = true
  raw       = true
}

resource "gitlab_group_variable" "platform_bitwarden_email" {
  group     = gitlab_group.platform.id
  key       = "TF_VAR_bitwarden_email"
  value     = module.bw_platform_bitwarden_user.data.username
  protected = false
  masked    = false
  raw       = true
}


resource "gitlab_user" "platform_runner_sa" {
  name             = "Platform Runner Service Account"
  username         = module.bw_platform_gitlab_user.data.username
  password         = module.bw_platform_gitlab_user.data.password
  email            = "${module.bw_platform_gitlab_user.data.username}@mail.adm.acme.corp"
  is_admin         = false
  can_create_group = false
  is_external      = false
  reset_password   = false
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
  expires_at = "2025-01-10"
  scopes     = ["api", "read_api"]
}

resource "local_sensitive_file" "platform_runner_sa_pat" {
  content  = gitlab_personal_access_token.platform_runner_sa.token
  filename = ".terraform/platform_runner_sa_pat.out"
}

resource "gitlab_project" "platform_group_self_config" {
  name                          = "iac-gitlab-group-platform"
  namespace_id                  = gitlab_group.platform.id
  visibility_level              = "private"
  builds_access_level           = "private"
  wiki_enabled                  = false
  packages_enabled              = false
  default_branch                = "main"
  merge_method                  = "merge"
  auto_cancel_pending_pipelines = "enabled"
  auto_devops_enabled           = false
}
