locals {
  project_id = var.random_id ? "${var.project_id}-${random_id.default.hex}" : var.project_id
  project    = google_project.new_project
}


resource "random_id" "default" {
  byte_length = 4
}


resource "google_project" "new_project" {
  name                = var.project_id
  project_id          = local.project_id
  folder_id           = var.folder_id
  billing_account     = var.billing_account
  auto_create_network = false
}


# Enable required APIs
resource "google_project_service" "enable_required_services" {
  project            = local.project_id
  disable_on_destroy = false
  for_each = toset([
    "artifactregistry.googleapis.com",
    "cloudbuild.googleapis.com",
    "compute.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iamcredentials.googleapis.com",
    "iam.googleapis.com",
    "container.googleapis.com",
    "cloudtrace.googleapis.com",
    "monitoring.googleapis.com",
    "logging.googleapis.com",
    "notebooks.googleapis.com",
    "aiplatform.googleapis.com",
    "file.googleapis.com",
    "servicenetworking.googleapis.com",
    "storage.googleapis.com",
    "run.googleapis.com"
  ])
  service = each.key
}
