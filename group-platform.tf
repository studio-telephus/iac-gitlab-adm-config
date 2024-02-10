resource "gitlab_group" "platform" {
  name             = "platform"
  description      = "Platform Team"
  path             = "platform"
  visibility_level = "private"
}

# Add only variables necessary to run the self-config repository
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

resource "gitlab_project" "iac-gitlab-group-platform" {
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

resource "gitlab_project" "iac-gitlab-users" {
  name                          = "iac-gitlab-users"
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
