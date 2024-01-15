resource "gitlab_group" "iam" {
  name             = "iam"
  description      = "Identity & Access Management Team"
  path             = "iam"
  visibility_level = "private"
}

resource "gitlab_group_variable" "iam_minio_adm_sa_access_key" {
  group             = gitlab_group.iam.id
  key               = "MINIO_ADM_SA_ACCESS_KEY"
  value             = module.minio_sa_api_key_iam.data.username
  protected         = false
  masked            = true
}

resource "gitlab_group_variable" "iam_minio_adm_sa_secret_key" {
  group             = gitlab_group.iam.id
  key               = "MINIO_ADM_SA_SECRET_KEY"
  value             = module.minio_sa_api_key_iam.data.password
  protected         = false
  masked            = true
}
