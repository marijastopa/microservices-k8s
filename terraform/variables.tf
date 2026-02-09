variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "europe-west1"
}

variable "cluster_name" {
  description = "GKE Cluster Name"
  type        = string
  default     = "microservices-cluster"
}

variable "labels" {
  description = "Labels to apply to all resources"
  type        = map(string)
  default = {
    environment = "dev"
    managed-by  = "terraform"
    project     = "microservices-demo"
  }
}