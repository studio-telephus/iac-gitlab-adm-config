resource "gitlab_group" "terraform" {
  name             = "terraform"
  description      = "Terraform Modules"
  path             = "terraform"
  visibility_level = "internal"
}

resource "gitlab_project" "terraform_group_self_config" {
  name                          = "iac-gitlab-group-terraform"
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
