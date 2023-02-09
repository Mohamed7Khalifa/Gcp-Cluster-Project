resource "google_compute_subnetwork" "restricted_subnet" {
  name                     = "restricted-subnet"
  ip_cidr_range            = "10.0.0.0/18"
  region                   = "asia-east1"
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "k8s-pod-range"
    ip_cidr_range = "10.48.0.0/14"
  }

  secondary_ip_range {
    range_name    = "k8s-service-range"
    ip_cidr_range = "10.52.0.0/20"
  }

}

resource "google_compute_subnetwork" "management_subnet" {
  name          = "management-subnet"
  ip_cidr_range = "10.1.0.0/18"
  region        = "asia-east1"
  network       = google_compute_network.vpc.self_link
  private_ip_google_access = true
}

resource "google_compute_firewall" "management_subnet_firewall" {
  name    = "management-subnet-firewall"
  network = google_compute_network.vpc.id
  direction = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["management-vm"]
  priority = 100
  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }
}