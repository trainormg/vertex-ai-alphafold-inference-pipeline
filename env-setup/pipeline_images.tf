# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

// Provision a artifact registry for alphafold_components images
resource "google_artifact_registry_repository" "alphafold_components" {
  depends_on    = [google_project_service.enable_required_services]
  project       = local.project_id
  location      = var.region
  repository_id = var.ar_repo_name
  format        = "DOCKER"
  description   = "Alphafold Components kfp image"
}


resource "null_resource" "pipeline_images1" {
  depends_on = [
    google_artifact_registry_repository.alphafold_components
  ]

  triggers = {
    full_image_path = "${var.region}-docker.pkg.dev/${local.project_id}/${var.ar_repo_name}/alphafold-components"
  }

  provisioner "local-exec" {
    when    = create
    command = <<-EOT
      cd ..
      gcloud builds submit . --timeout "2h" \
      --region=${var.region} \
      --project=${local.project_id} \
      --config=alphafold.yml \
      --substitutions=_CONTAINER_IMAGE_TAG=${self.triggers.full_image_path} \
      --machine-type=e2-highcpu-8 --async
      EOT
  }
}


resource "null_resource" "pipeline_images2" {
  depends_on = [
    google_artifact_registry_repository.alphafold_components
  ]

  triggers = {
    full_image_path = "${var.region}-docker.pkg.dev/${local.project_id}/${var.ar_repo_name}/alphafold-components"
  }

  provisioner "local-exec" {
    when    = create
    command = <<-EOT
      cd ..
      gcloud builds submit . --timeout "2h" \
      --region=${var.region} \
      --project=${local.project_id} \
      --config=alphafold-cuda1111.yml \
      --substitutions=_CONTAINER_IMAGE_TAG=${self.triggers.full_image_path} \
      --machine-type=e2-highcpu-8  --async
      EOT
  }
}
