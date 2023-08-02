# ---------------------------------------------------------------------------------------------------------------------
# Repository settings
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "(Required) The name of the repository."
  type        = string
}

variable "description" {
  description = "(Optional) A description of the repository."
  type        = string
  default     = ""
}

variable "visibility" {
  description = "(Optional) Can be 'public', 'private' or 'internal' (GHE only). (Default: 'private')"
  type        = string
  default     = "private"
  validation {
    condition     = contains(["public", "private", "internal"], var.visibility)
    error_message = "Repository visibility must be one of `public`, `private`, `internal`."
  }
}

variable "homepage_url" {
  description = "(Optional) The website of the repository."
  type        = string
  default     = null
}

variable "topics" {
  description = "(Optional) The list of topics of the repository. (Default: [])"
  type        = list(string)
  default     = null
}

variable "auto_init" {
  description = "(Optional) Wether or not to produce an initial commit in the repository. (Default: true)"
  type        = bool
  default     = true
}

variable "archived" {
  description = "(Optional) Specifies if the repository should be archived. (Default: false)"
  type        = bool
  default     = false
}

variable "archive_on_destroy" {
  type        = string
  description = "(Optional) Set to `false` to not archive the repository instead of deleting on destroy."
  default     = true
}

variable "template" {
  description = "(Optional) Template repository to use. (Default: {})"
  type = object({
    owner      = string
    repository = string
  })
  default = null
}

# ---------------------------------------------------------------------------------------------------------------------
# Repository features
# ---------------------------------------------------------------------------------------------------------------------

variable "has_discussions" {
  description = "(Optional) Set to true to enable the GitHub Discussions features on the repository. (Default: false)"
  type        = bool
  default     = false
}

variable "has_issues" {
  description = "(Optional) Set to true to enable the GitHub Issues features on the repository. (Default: false)"
  type        = bool
  default     = false
}

variable "has_projects" {
  description = "(Optional) Set to true to enable the GitHub Projects features on the repository. (Default: false)"
  type        = bool
  default     = false
}

variable "has_wiki" {
  description = "(Optional) Set to true to enable the GitHub Wiki features on the repository. (Default: false)"
  type        = bool
  default     = false
}

# ---------------------------------------------------------------------------------------------------------------------
# Pull Request settings
# ---------------------------------------------------------------------------------------------------------------------

variable "allow_merge_commit" {
  description = "(Optional) Set to false to disable merge commits on the repository. (Default: true)"
  type        = bool
  default     = true
}

variable "allow_squash_merge" {
  description = "(Optional) Set to true to enable squash merges on the repository. (Default: false)"
  type        = bool
  default     = false
}

variable "allow_rebase_merge" {
  description = "(Optional) Set to true to enable rebase merges on the repository. (Default: false)"
  type        = bool
  default     = false
}

variable "allow_auto_merge" {
  description = "(Optional) Set to true to allow auto-merging pull requests on the repository. If enabled for a pull request, the pull request will merge automatically when all required reviews are met and status checks have passed. (Default: false)"
  type        = bool
  default     = false
}

variable "delete_branch_on_merge" {
  description = "(Optional) Whether or not to delete the merged branch after merging a pull request. (Default: false)"
  type        = bool
  default     = false
}

variable "allow_update_branch" {
  description = "Set to `true` to suggest updating pull request branches."
  type        = bool
  default     = false
}

variable "merge_commit_title" {
  description = "(Optional) Can be `PR_TITLE` or `MERGE_MESSAGE` for a default merge commit title. (Default: 'PR_TITLE')"
  type        = string
  default     = "PR_TITLE"
  validation {
    condition     = contains(["PR_TITLE", "MERGE_MESSAGE"], var.merge_commit_title)
    error_message = "Merge commit title must be one of `PR_TITLE`, `MERGE_MESSAGE`."
  }
}
variable "merge_commit_message" {
  description = "(Optional) Can be `PR_BODY`, `PR_TITLE`, or `BLANK` for a default merge commit message. (Default: 'PR_TITLE')"
  type        = string
  default     = "PR_BODY"
  validation {
    condition     = contains(["PR_BODY", "PR_TITLE", "BLANK"], var.merge_commit_message)
    error_message = "Merge commit message must be one of `PR_BODY`, `PR_TITLE`, `BLANK`."
  }
}
variable "squash_merge_commit_title" {
  description = "(Optional) Can be `PR_TITLE` or `COMMIT_OR_PR_TITLE` for a default squash merge commit title. (Default: 'PR_TITLE')"
  type        = string
  default     = "PR_TITLE"
  validation {
    condition     = contains(["PR_TITLE", "COMMIT_OR_PR_TITLE"], var.squash_merge_commit_title)
    error_message = "Squash merge commit title must be one of `PR_TITLE`, `COMMIT_OR_PR_TITLE`."
  }
}
variable "squash_merge_commit_message" {
  description = "(Optional) Can be `PR_BODY`, `COMMIT_MESSAGES`, or `BLANK` for a default squash merge commit message. (Default: 'PR_BODY')"
  type        = string
  default     = "PR_BODY"
  validation {
    condition     = contains(["PR_BODY", "COMMIT_MESSAGES", "BLANK"], var.squash_merge_commit_message)
    error_message = "Squash merge commit message must be one of `PR_BODY`, `COMMIT_MESSAGES`, `BLANK`."
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Branches
# ---------------------------------------------------------------------------------------------------------------------

variable "branches" {
  description = "(Optional) A list of branches to be created in this repository. (Default [])"
  type = list(object({
    name          = string
    source_branch = optional(string)
    source_sha    = optional(string)
  }))

  # Example:
  # branches = [
  #   {
  #     "name"          = "development"
  #     "source_branch" = "main"
  #   }
  # ]

  default = []
}

# ---------------------------------------------------------------------------------------------------------------------
# Branch protection settings
# See https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_protection for
# more details
# ---------------------------------------------------------------------------------------------------------------------

variable "branch_protections_v4" {
  description = "(Optional) A list of v4 branch protections to apply to the repository. Default is []."
  type = list(
    object(
      {
        pattern                         = string
        allows_deletions                = optional(bool, false)
        allows_force_pushes             = optional(bool, false)
        blocks_creations                = optional(bool, false)
        enforce_admins                  = optional(bool, false)
        push_restrictions               = optional(list(string), [])
        force_push_bypassers            = optional(list(string), [])
        require_conversation_resolution = optional(bool, false)
        require_signed_commits          = optional(bool, false)
        required_linear_history         = optional(bool, false)
        required_pull_request_reviews = optional(object(
          {
            dismiss_stale_reviews           = optional(bool, false)
            dismissal_restrictions          = optional(list(string), [])
            pull_request_bypassers          = optional(list(string), [])
            require_code_owner_reviews      = optional(bool, false)
            required_approving_review_count = optional(number, 0)
          }
        ))
        required_status_checks = optional(object(
          {
            strict   = optional(bool, false)
            contexts = optional(list(string), [])
          }
        ))
      }
    )
  )
  validation {
    condition = alltrue(
      [
        for cfg in var.branch_protections_v4 : try(
          cfg.required_pull_request_reviews.required_approving_review_count >= 0
          && cfg.required_pull_request_reviews.required_approving_review_count <= 6,
          true
        )
      ]
    )
    error_message = "The value for branch_protections_v4.required_pull_request_reviews.required_approving_review_count must be between 0 and 6, inclusively."
  }

  default = []
}

# ---------------------------------------------------------------------------------------------------------------------
# Issue labels
# ---------------------------------------------------------------------------------------------------------------------

variable "issue_labels_manage_default_github_labels" {
  description = "(Optional) Manage the default GitHub labels. (Default: false)"
  type        = bool
  default     = false
}

variable "issue_labels" {
  description = "(Optional) Configure a GitHub issue label resource. (Default: [])"
  type = list(object({
    name        = string
    description = string
    color       = string
  }))
  default = []
}

# ---------------------------------------------------------------------------------------------------------------------
# Collaborators
# ---------------------------------------------------------------------------------------------------------------------

variable "collaborators" {
  description = "(Optional) A list of users to add as collaborators granting them the specified permission. (Default: [])"
  type = list(object({
    username   = string
    permission = optional(string, "push")
  }))

  validation {
    condition = alltrue([
      for o in var.collaborators : contains(["pull", "push", "maintain", "triage", "admin"], o.permission)
    ])
    error_message = "Collaborator permission must be one of `pull`, `push`, `maintain`, `triage`, `admin`."
  }

  # Example:
  # collaborators = [
  #   {
  #     "username" = "johndoe"
  #     "permission" = "maintain"
  #   }
  # ]

  default = []
}

# ---------------------------------------------------------------------------------------------------------------------
# Deploy keys
# ---------------------------------------------------------------------------------------------------------------------

variable "deploy_keys" {
  description = "(Optional) Configure deploy keys that grants access to a single GitHub repository. This key is attached directly to the repository instead of to a personal user account. (Default: [])"
  type = list(object({
    title     = string
    key       = string
    read_only = optional(bool, true)
  }))

  # Example:
  # deploy_keys = [
  #   {
  #     title     = "CI User Deploy Key"
  #     key       = "ssh-rsa AAAAB3NzaC1yc2...."
  #     read_only = true
  #   },
  #   {
  #     title     = "Test Key"
  #     key       = "ssh-rsa AAAAB3NzaC1yc2...."
  #     read_only = false
  #   }
  # ]

  default = []
}

# ---------------------------------------------------------------------------------------------------------------------
# GitHub Pages configuration
# ---------------------------------------------------------------------------------------------------------------------

variable "pages" {
  description = "(Optional) The repository's GitHub Pages configuration. (Default: {})"
  type = object({
    build_type = optional(string, "workflow")
    branch     = string
    path       = optional(string, "/")
    cname      = optional(string)
  })
  validation {
    condition     = var.pages != null ? contains(["workflow", "legacy"], var.pages.build_type) : true
    error_message = "GitHub pages build type must be one of `workflow`, `legacy`."
  }

  default = null
}

# ---------------------------------------------------------------------------------------------------------------------
# Action Secrets
# ---------------------------------------------------------------------------------------------------------------------

variable "plaintext_secrets" {
  description = "(Optional) Configuring actions secrets. For details please check: https://www.terraform.io/docs/providers/github/r/actions_secret"
  type        = map(string)

  # Example:
  # plaintext_secrets = {
  #     "MY_SECRET" = "42"
  #     "OWN_TOKEN" = "12345"
  # }

  default = {}
}

variable "encrypted_secrets" {
  description = "(Optional) Configuring encrypted actions secrets. For details please check: https://www.terraform.io/docs/providers/github/r/actions_secret"
  type        = map(string)

  # Example:
  # encrypted_secrets = {
  #     "MY_ENCRYPTED_SECRET" = "MTIzNDU="
  # }

  default = {}
}

# ---------------------------------------------------------------------------------------------------------------------
# Webhooks
# ---------------------------------------------------------------------------------------------------------------------

variable "webhooks" {
  description = "(Optional) Configuring webhooks. For details please check: https://www.terraform.io/docs/providers/github/r/repository_webhook.html. (Default: [])"
  type = list(object({
    active       = optional(bool, true)
    events       = list(string)
    url          = string
    content_type = optional(string, "json")
    insecure_ssl = optional(bool, false)
    secret       = optional(string)
  }))

  validation {
    condition = alltrue([
      for o in var.webhooks : contains(["form", "json"], o.content_type)
    ])
    error_message = "Webhook content type must be one of `form`, `json`."
  }

  # Example:
  # webhooks = [{
  #   active = false
  #   events = ["issues"]
  #   url          = "https://google.de/"
  #   content_type = "form"
  #   insecure_ssl = false
  # }]

  default = []
}

# ---------------------------------------------------------------------------------------------------------------------
# Autolink references
# ---------------------------------------------------------------------------------------------------------------------

variable "autolink_references" {
  description = "(Optional) Configuring autolink references. For details please check: https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_autolink_reference. (Default: [])"
  type = list(object({
    key_prefix          = string
    target_url_template = string
  }))

  validation {
    condition = alltrue([
      for o in var.autolink_references : can(regex("<num>", o.target_url_template))
    ])
    error_message = "Autolink reference template must contain the `<num>` token."
  }

  # Example:
  # autolink_references = [
  #   {
  #     key_prefix          = "TICKET-"
  #     target_url_template = "https://hello.there/TICKET?query=<num>"
  #   }
  # ]

  default = []
}
