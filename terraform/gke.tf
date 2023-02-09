resource "google_container_cluster" "private_cluster" {
  name                     = "private-cluster"
  location                 = "asia-east1"
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = google_compute_network.vpc.self_link
  subnetwork               = google_compute_subnetwork.restricted_subnet.self_link
  logging_service          = "logging.googleapis.com/kubernetes"
  monitoring_service       = "monitoring.googleapis.com/kubernetes"
  networking_mode          = "VPC_NATIVE"

  node_locations = [
    "asia-east1-b"
  ]

  addons_config {
    http_load_balancing {
      disabled = false
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
  }

  master_authorized_networks_config {
    cidr_blocks {
        cidr_block = "10.1.0.0/18"
        display_name = "management_subnet"
    }
  }
  release_channel {
    channel = "REGULAR"
  }

  workload_identity_config {
    workload_pool = "khalifa-iti-project.svc.id.goog"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "k8s-pod-range"
    services_secondary_range_name = "k8s-service-range"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

}

#-------------------------"node-pool"-----------------------
resource "google_container_node_pool" "cluster_node_pool" {
  name       = "cluster-node-pool"
  location   = "asia-east1"
  cluster    = google_container_cluster.private_cluster.name
  node_count = 1

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    preemptible  = false
    machine_type = "e2-small"
    service_account = google_service_account.kubernetes.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

#--------------------------"service account"-----------------------
resource "google_service_account" "kubernetes" {
  account_id = "kubernetes"
  display_name = "sa-gke"
}

resource "google_project_iam_member" "gke_sa_viewer" {
  project = "khalifa-iti-project"
  role = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.kubernetes.email}"
}


