resource "github_branch" "branch" {
  for_each = { for b in var.branches : b.name => b }

  repository    = github_repository.repository.name
  branch        = each.key
  source_branch = each.value.source_branch
  source_sha    = each.value.source_sha
}
