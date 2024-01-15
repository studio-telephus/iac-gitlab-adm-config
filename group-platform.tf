resource "gitlab_group" "platform" {
  name             = "platform"
  description      = "Platform Team"
  path             = "platform"
  visibility_level = "private"
}

resource "gitlab_group_variable" "platform_minio_adm_sa_access_key" {
  group             = gitlab_group.platform.id
  key               = "MINIO_ADM_SA_ACCESS_KEY"
  value             = module.minio_sa_api_key_platform.data.username
  protected         = false
  masked            = true
}

resource "gitlab_group_variable" "platform_minio_adm_sa_secret_key" {
  group             = gitlab_group.platform.id
  key               = "MINIO_ADM_SA_SECRET_KEY"
  value             = module.minio_sa_api_key_platform.data.password
  protected         = false
  masked            = true
}
