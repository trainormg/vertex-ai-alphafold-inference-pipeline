# Copyright 2021 Google LLC
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

locals {
  image_project = "deeplearning-platform-release"
}

resource "google_notebooks_instance" "notebook_instance" {
  depends_on   = [google_project_service.enable_required_services]
  name         = var.workbench_instance_name
  machine_type = var.machine_type
  location     = var.zone

  network = google_compute_network.network.self_link
  subnet  = google_compute_subnetwork.subnetwork.self_link

  vm_image {
    project      = local.image_project
    image_family = var.image_family
  }

  metadata = {
    terraform = "true"
  }

  boot_disk_size_gb   = var.boot_disk_size
  no_remove_data_disk = false

  labels = {
    goog-packaged-solution = "target-and-lead-id"
  }

  project      = var.project_id
  no_public_ip = true
  lifecycle {
    ignore_changes = [
      tags,
      disk_encryption,
      service_account_scopes
    ]
  }
}
