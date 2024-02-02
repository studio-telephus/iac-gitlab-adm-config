variable "gitlab_endpoint" {
  type    = string
  default = "https://gitlab.docker.adm.acme.corp/gitlab"
}

variable "tags" {
  type = map(string)
}
