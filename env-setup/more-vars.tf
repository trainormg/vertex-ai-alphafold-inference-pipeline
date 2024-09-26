variable "terraform_sa" {
  description = "Service Account to use in terraform provider."
  type        = string
  default     = null
}

variable "billing_account" {
  description = "Billing account id."
  type        = string
  default     = null
}

variable "folder_id" {
  description = "Folder ID where the project should be created."
  type        = string
}

variable "random_id" {
  description = "Adds a suffix of 8 random characters to the `project_id`"
  type        = bool
  default     = true
}

variable "create_project" {
  description = "Create a new project or use an existing one."
  type        = bool
  default     = true
}
