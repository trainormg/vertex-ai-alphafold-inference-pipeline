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


resource "local_file" "job-template" {
  filename        = "bin/vertex-training-job.yaml"
  file_permission = "0666"
  content = templatefile("vertex-training-job.tftpl", {
    NETWORK_ID   = "projects/${local.project.number}/global/networks/${google_compute_network.network.name}"
    GCS_PATH     = "gs://${var.gcs_dbs_path}"
    MOUNT_POINT  = "/mnt/nfs/alphafold"
    FILESTORE_IP = google_filestore_instance.filestore_instance.networks.0.ip_addresses.0
    FILESHARE    = google_filestore_instance.filestore_instance.file_shares.0.name
  })

  provisioner "local-exec" {
    command = <<-EOT
      gsutil -m cp -r gs://${var.gcs_dbs_path}/params/ gs://${google_storage_bucket.artifact_repo.name}
      gcloud ai custom-jobs create --region ${var.region} --display-name populate_filestore --config bin/vertex-training-job.yaml --project ${local.project_id}
    EOT
  }
}

# TODO:
# the gcs_dbs_path bucket is not found or not accessible (403).
# Data may be downloaded from https://github.com/google-deepmind/alphafold#genetic-databases
# Create a cloud run job to download and unzip data from alphafold repo
# (see scripts/ there) and copy it to filestore.
# This way, this local provisioner could be removed.
# Can the job process the many different downloads in parallel?


# resource "null_resource" "copy_datasets" {
#   depends_on = [google_project_service.enable_required_services]

#   triggers = {
#     always_run     = timestamp()
#     REGION         = var.region
#     PROJECT_ID     = local.project.project_id
#     PROJECT_NUMBER = local.project.number
#     NETWORK_ID     = google_compute_network.network.id
#     FILESTORE_IP   = google_filestore_instance.filestore_instance.networks.0.ip_addresses.0
#     FILESHARE      = google_filestore_instance.filestore_instance.file_shares.0.name
#   }

#   provisioner "local-exec" {
#     command = <<EOT
#                 NETWORK_ID=$(echo ${self.triggers.NETWORK_ID} | sed "s#${self.triggers.PROJECT_ID}#${self.triggers.PROJECT_NUMBER}#")
#                 GCS_PATH=gs://${var.gcs_dbs_path}
#                 GCS_PARAMS_PATH=gs://${google_storage_bucket.artifact_repo.name}
#                 MOUNT_POINT=/mnt/nfs/alphafold

#                 gsutil -m cp -r $GCS_PATH/params/ $GCS_PARAMS_PATH

#                 sed -i s#NETWORK_ID#$NETWORK_ID#g vertex-training-template.yaml 
#                 sed -i s#FILESTORE_IP#${self.triggers.FILESTORE_IP}#g vertex-training-template.yaml
#                 sed -i s#FILESHARE#${self.triggers.FILESHARE}#g vertex-training-template.yaml
#                 sed -i s#MOUNT_POINT#$MOUNT_POINT#g vertex-training-template.yaml
#                 sed -i s#GCS_PATH#$GCS_PATH#g vertex-training-template.yaml

#                 gcloud ai custom-jobs create --region ${self.triggers.REGION} --display-name populate_filestore --config vertex-training-template.yaml --project ${self.triggers.PROJECT_ID}
#                 EOT
#   }

#   provisioner "local-exec" {
#     when       = destroy
#     command    = <<EOT
#                 gcloud ai custom-jobs cancel $(gcloud ai custom-jobs list --project=${self.triggers.PROJECT_ID} --region=${self.triggers.REGION} --filter="displayName: populate_filestore AND (state: JOB_STATE_PENDING OR state: JOB_STATE_RUNNING)" --limit=1 | grep -e "name" | awk '{ print $2}') --region=${self.triggers.REGION}
#                 EOT
#     on_failure = continue
#   }

# }
