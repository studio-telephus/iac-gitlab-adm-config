resource "gitlab_group" "terraform" {
  name             = "terraform"
  description      = "Terraform Modules"
  path             = "terraform"
  visibility_level = "internal"
}
