resource "github_repository_webhook" "repository_webhook" {
  count = length(var.webhooks)

  repository = github_repository.repository.name
  active     = var.webhooks[count.index].active
  events     = var.webhooks[count.index].events

  configuration {
    url          = var.webhooks[count.index].url
    content_type = var.webhooks[count.index].content_type
    insecure_ssl = var.webhooks[count.index].insecure_ssl
    secret       = var.webhooks[count.index].secret
  }
}
