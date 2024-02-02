resource "gitlab_instance_variable" "MINIO_ADM_S3_ENDPOINT" {
  key       = "MINIO_ADM_S3_ENDPOINT"
  value     = "https://minio.docker.adm.acme.corp:9000"
  protected = false
  masked    = false
}
