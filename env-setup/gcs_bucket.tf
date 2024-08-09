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


locals {
  gcs_bucket_name = "${local.project_id}-${var.gcs_bucket_name}"
}


resource "google_storage_bucket" "artifact_repo" {
  depends_on = [google_project_service.enable_required_services]

  name                        = local.gcs_bucket_name
  location                    = var.region
  storage_class               = "REGIONAL"
  force_destroy               = var.force_destroy
  uniform_bucket_level_access = var.uniform_bucket_access
  project                     = local.project_id

  labels = {
    goog-packaged-solution = "target-and-lead-id"
  }

  soft_delete_policy {
    retention_duration_seconds = 0
  }
}
