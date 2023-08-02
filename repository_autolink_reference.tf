resource "github_repository_autolink_reference" "repository_autolink_reference" {
  for_each = { for autolink in var.autolink_references : autolink.key_prefix => autolink }

  repository          = github_repository.repository.name
  key_prefix          = each.value.key_prefix
  target_url_template = each.value.target_url_template
  is_alphanumeric     = each.value.is_alphanumeric
}
