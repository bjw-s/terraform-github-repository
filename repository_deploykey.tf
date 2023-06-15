resource "github_repository_deploy_key" "deploy_key" {
  for_each = { for key in var.deploy_keys : key.title => key }

  repository = github_repository.repository.name
  title      = each.value.title
  key        = each.value.key
  read_only  = each.value.read_only
}
