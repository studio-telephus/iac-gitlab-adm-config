provider "gitlab" {
  base_url = var.gitlab_endpoint
  token    = module.gitlab_sa_api_key.data.password
}
