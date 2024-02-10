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

resource "gitlab_project" "iac-gitlab-group-iam" {
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
