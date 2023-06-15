resource "github_repository_collaborator" "collaborator" {
  for_each = { for col in var.collaborators : col.username => col }

  repository = github_repository.repository.name
  username   = each.value.username
  permission = each.value.permission
}
