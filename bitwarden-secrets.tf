module "gitlab_admin_api_key" {
  source = "github.com/studio-telephus/terraform-bitwarden-get-item-login.git?ref=1.0.0"
  id     = "71c1634f-867a-43f2-b7b6-b0f500ae3e17"
}

module "minio_sa_api_key_iam" {
  source = "github.com/studio-telephus/terraform-bitwarden-get-item-login.git?ref=1.0.0"
  id     = "9daa1ab6-6a06-447f-a108-b0f700694052"
}

module "minio_sa_api_key_platform" {
  source = "github.com/studio-telephus/terraform-bitwarden-get-item-login.git?ref=1.0.0"
  id     = "901308ae-c614-432d-b4b5-b0f700655e20"
}

module "bw_gitlab_user_platform_runner_sa" {
  source = "github.com/studio-telephus/terraform-bitwarden-get-item-login.git?ref=1.0.0"
  id     = "b0a2beb3-4be5-4331-94e8-b0f500e8c694"
}

module "bw_gitlab_user_iam_runner_sa" {
  source = "github.com/studio-telephus/terraform-bitwarden-get-item-login.git?ref=1.0.0"
  id     = "afb3769e-2ed7-4aa6-99e8-b0f800d4d6d8"
}

module "bw_platform_bitwarden_user" {
  source = "github.com/studio-telephus/terraform-bitwarden-get-item-login.git?ref=1.0.0"
  id     = "26d40c85-98f6-4bc1-82f4-b0f500ae7ebf"
}

module "bw_iam_bitwarden_user" {
  source = "github.com/studio-telephus/terraform-bitwarden-get-item-login.git?ref=1.0.0"
  id     = "60ebf2b9-50c6-4996-85c9-b0f500d8d3b5"
}
