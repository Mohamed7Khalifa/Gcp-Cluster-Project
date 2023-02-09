resource "google_compute_router" "route_table" {
  name    = "route_table"
  region  = "asia-east1"
  network = google_compute_network.vpc.id
}