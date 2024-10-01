# module "nat" {
#   source         = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/net-cloudnat?ref=v34.1.0&depth=1"
#   project_id     = var.project_id
#   region         = var.region
#   router_network = google_compute_network.network.self_link
#   name           = var.network_name
# }


resource "google_compute_router" "router" {
  name    = "${var.network_name}-${var.region}-nat-router"
  project = var.project_id
  region  = var.region
  network = google_compute_network.network.self_link
}

resource "google_compute_router_nat" "nat" {
  project                             = var.project_id
  region                              = var.region
  name                                = "${var.network_name}-${var.region}-nat"
  router                              = google_compute_router.router.name
  nat_ip_allocate_option              = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat  = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  enable_dynamic_port_allocation      = true
  enable_endpoint_independent_mapping = false
}
