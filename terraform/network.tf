# VPC Network
resource "google_compute_network" "vpc" {
  name                    = "${var.cluster_name}-vpc"
  auto_create_subnetworks = false
}

# Primary subnet for nodes
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.cluster_name}-subnet"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.0.0.0/20" 
  
  # Secondary IP ranges for GKE
  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = "10.4.0.0/14"  
  }
  
  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = "10.8.0.0/20" 
  }
  
  # Enable private Google access for pulling images from GCR
  private_ip_google_access = true
}
