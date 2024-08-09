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

resource "google_compute_network" "network" {
  name                    = var.network_name
  auto_create_subnetworks = "false"
  routing_mode            = "REGIONAL"
  project                 = local.project_id
  depends_on              = [google_project_service.enable_required_services]
}

resource "google_compute_subnetwork" "subnetwork" {
  name                     = var.subnet_name
  region                   = var.region
  network                  = google_compute_network.network.self_link
  ip_cidr_range            = var.subnet_ip_range
  project                  = local.project_id
  private_ip_google_access = true
}

resource "google_compute_global_address" "private_ip_alloc_service_networking" {
  provider      = google-beta
  name          = "${var.network_name}-private-ip-alloc"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  address       = split("/", var.peering_ip_range)[0]
  prefix_length = split("/", var.peering_ip_range)[1]
  network       = google_compute_network.network.id
  project       = local.project_id

  labels = {
    goog-packaged-solution = "target-and-lead-id"
  }
}

resource "google_service_networking_connection" "service_connection" {
  network                 = google_compute_network.network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc_service_networking.name]
}


