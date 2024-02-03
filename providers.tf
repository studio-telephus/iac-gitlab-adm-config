provider "gitlab" {
  base_url = var.gitlab_endpoint
  token    = module.gitlab_admin_api_key.data.password
}
