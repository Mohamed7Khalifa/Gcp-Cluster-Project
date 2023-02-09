resource "google_compute_router" "route_table" {
  name    = "route-table"
  region  = "asia-east1"
  network = google_compute_network.vpc.self_link
}

resource "google_compute_router_nat" "nat_gateway" {
  name   = "nat-gateway"
  router = google_compute_router.route_table.name
  region = "asia-east1"

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  nat_ip_allocate_option             = "AUTO_ONLY"

  subnetwork {
    name                    = google_compute_subnetwork.management_subnet.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
  
  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
