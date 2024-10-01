locals {
  project_id = var.random_id ? "${var.project_name}-${random_id.default.hex}" : var.project_name
  project    = google_project.new_project
}


resource "random_id" "default" {
  byte_length = 4
}


resource "google_project" "new_project" {
  name                = var.project_name
  project_id          = local.project_id
  folder_id           = var.folder_id
  billing_account     = var.billing_account
  auto_create_network = false
}

