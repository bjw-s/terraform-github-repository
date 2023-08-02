resource "github_repository" "repository" {
  name         = var.name
  description  = var.description
  topics       = var.topics
  homepage_url = var.homepage_url

  visibility = var.visibility
  auto_init  = var.auto_init

  archived           = var.archived
  archive_on_destroy = var.archive_on_destroy

  # Repository features
  has_discussions = var.has_discussions
  has_issues      = var.has_issues
  has_projects    = var.has_projects
  has_wiki        = var.has_wiki

  # Pull Request settings
  allow_merge_commit     = var.allow_merge_commit
  allow_rebase_merge     = var.allow_rebase_merge
  allow_squash_merge     = var.allow_squash_merge
  allow_auto_merge       = var.allow_auto_merge
  delete_branch_on_merge = var.delete_branch_on_merge

  allow_update_branch    = var.allow_update_branch

  merge_commit_message        = var.allow_merge_commit ? var.merge_commit_message : null
  merge_commit_title          = var.allow_merge_commit ? var.merge_commit_title : null
  squash_merge_commit_message = var.allow_squash_merge ? var.squash_merge_commit_message : null
  squash_merge_commit_title   = var.allow_squash_merge ? var.squash_merge_commit_title : null

  # Template settings
  dynamic "template" {
    for_each = var.template != null ? [true] : []

    content {
      owner      = var.template.owner
      repository = var.template.repository
    }
  }

  # GitHub Pages settings
  dynamic "pages" {
    for_each = var.pages != null ? [true] : []

    content {
      build_type = var.pages.build_type
      source {
        branch = var.pages.branch
        path   = var.pages.path
      }
      cname = var.pages.cname
    }
  }

  lifecycle {
    ignore_changes = [
      auto_init,
      template
    ]
  }
}
