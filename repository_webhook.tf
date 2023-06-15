resource "github_repository_webhook" "repository_webhook" {
  for_each = { for hook in var.webhooks : lookup(hook, "id", hook.url) => hook }

  repository = github_repository.repository.name
  active     = each.value.active
  events     = each.value.events

  configuration {
    url          = each.value.url
    content_type = each.value.content_type
    insecure_ssl = each.value.insecure_ssl
    secret       = each.value.secret
  }
}
