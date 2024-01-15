variable "gitlab_endpoint" {
  type    = string
  default = "https://gitlab.adm.acme.corp/gitlab"
}

variable "tags" {
  type = map(string)
}
