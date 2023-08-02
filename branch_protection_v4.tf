resource "github_branch_protection" "branch_protection" {
  for_each = { for bp in var.branch_protections_v4 : bp.pattern => bp }

  # ensure we have all prerequisites added before applying
  # any configuration for them
  depends_on = [
    github_repository_collaborator.collaborator,
    github_branch.branch,
  ]

  repository_id = github_repository.repository.node_id

  pattern = each.value.pattern

  allows_deletions                = each.value.allows_deletions
  allows_force_pushes             = each.value.allows_force_pushes
  blocks_creations                = each.value.blocks_creations
  lock_branch                     = each.value.lock_branch
  enforce_admins                  = each.value.enforce_admins
  push_restrictions               = each.value.push_restrictions
  force_push_bypassers            = each.value.force_push_bypassers
  require_conversation_resolution = each.value.require_conversation_resolution
  require_signed_commits          = each.value.require_signed_commits
  required_linear_history         = each.value.required_linear_history

  dynamic "required_pull_request_reviews" {
    for_each = each.value.required_pull_request_reviews != null ? [each.value.required_pull_request_reviews] : []

    content {
      dismiss_stale_reviews           = required_pull_request_reviews.value.dismiss_stale_reviews
      restrict_dismissals             = required_pull_request_reviews.value.restrict_dismissals
      dismissal_restrictions          = required_pull_request_reviews.value.dismissal_restrictions
      pull_request_bypassers          = required_pull_request_reviews.value.pull_request_bypassers
      require_code_owner_reviews      = required_pull_request_reviews.value.require_code_owner_reviews
      required_approving_review_count = required_pull_request_reviews.value.required_approving_review_count
      require_last_push_approval      = required_pull_request_reviews.value.require_last_push_approval
    }
  }

  dynamic "required_status_checks" {
    for_each = each.value.required_status_checks != null ? [each.value.required_status_checks] : []

    content {
      strict   = required_status_checks.value.strict
      contexts = required_status_checks.value.contexts
    }
  }
}
