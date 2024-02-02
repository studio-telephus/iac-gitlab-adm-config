provider "gitlab" {
  base_url = var.gitlab_endpoint
  token    = module.gitlab_root_api_key.data.password
}
