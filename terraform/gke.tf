# Service Account for GKE nodes
resource "google_service_account" "gke_sa" {
  account_id   = "${var.cluster_name}-sa"
  display_name = "GKE Node Service Account"
}

# Grant permissions to pull images from GCR
resource "google_project_iam_member" "gke_sa_gcr" {
  project = var.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.gke_sa.email}"
}

# GKE Cluster
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region
  
  # Remove default node pool
  remove_default_node_pool = true
  initial_node_count       = 1
  
  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
  
  # IP allocation for VPC-native cluster (uses secondary ranges)
  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }
  
  # Workload Identity for secure pod-to-GCP authentication
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
  
  # Enable metrics and logging
  logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }
  
  monitoring_config {
    enable_components = ["SYSTEM_COMPONENTS"]
    managed_prometheus {
      enabled = true
    }
  }
  
  # Enable Horizontal Pod Autoscaling
  addons_config {
    horizontal_pod_autoscaling {
      disabled = false
    }
    http_load_balancing {
      disabled = false
    }
  }
  
  # Network policy for pod-to-pod security
  network_policy {
    enabled  = true
    provider = "PROVIDER_UNSPECIFIED"
  }
  
  resource_labels = var.labels
}

# Managed Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.cluster_name}-node-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = 2
  
  # Autoscaling configuration
  autoscaling {
    min_node_count = 2
    max_node_count = 5
  }
  
  node_config {
    machine_type = "e2-medium"
    disk_size_gb = 50
    disk_type    = "pd-standard"
    
    # Use custom service account with minimal permissions
    service_account = google_service_account.gke_sa.email
    
    # Enable Workload Identity
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
    
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    
    labels = var.labels
    
    metadata = {
      disable-legacy-endpoints = "true"
    }
    
    # Security: Use Container-Optimized OS
    image_type = "COS_CONTAINERD"
  }
  
  management {
    auto_repair  = true
    auto_upgrade = true
  }
}