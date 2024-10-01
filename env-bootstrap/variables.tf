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

variable "state_bucket_name" {
  description = "The GCS bucket name"
  type        = string
  default     = "tf-state-bucket"
}

variable "project_name" {
  description = "The GCP project ID prefix"
  type        = string
  default     = "vertex-ai-alphafold"
}
