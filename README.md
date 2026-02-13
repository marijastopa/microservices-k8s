# Microservices on GKE

Deployment of a microservices-based e-commerce app on Google Kubernetes Engine.

## Overview

This project containerizes and deploys 10 microservices from the Google Cloud demo repository. Infrastructure is managed with Terraform, applications are packaged with Helm, and deployment is automated with Helmfile.

## Stack

- Container images: Distroless, Alpine, Microsoft Chiseled
- Container registry: Google Artifact Registry
- Infrastructure: GKE cluster (Terraform)
- Deployment: Helm charts with Helmfile orchestration
- Session storage: Redis (Helm subchart)
- Security scanning: Trivy

## Services

- frontend (Go) - web interface
- productcatalogservice (Go) - product data
- cartservice (C#) - shopping cart with Redis
- checkoutservice (Go) - order processing
- paymentservice (Node.js) - payment handling
- shippingservice (Go) - shipping quotes
- currencyservice (Node.js) - currency conversion
- recommendationservice (Python) - product suggestions
- emailservice (Python) - order notifications
- adservice (Java) - advertisements

## Setup

Deploy infrastructure:
```bash
cd terraform
terraform init
terraform apply
```

Configure kubectl:
```bash
gcloud container clusters get-credentials microservices-cluster \
  --region europe-west1 \
  --project microservices-gke-486922
```

Deploy with Helmfile:
```bash
cd helmfile
export REDIS_PASSWORD="your-password"
helmfile sync --set redis.auth.password=$REDIS_PASSWORD
```

Or deploy with Helm directly:
```bash
cd helm
helm dependency update microservices
helm install microservices ./microservices \
  --set redis.auth.password=$REDIS_PASSWORD
```

Get frontend URL:
```bash
kubectl get svc frontend
```

## Features

- Horizontal pod autoscaling on frontend, checkout, and recommendation services
- Health checks on all deployments
- Network policies for namespace isolation
- Redis session storage with password management via Kubernetes secrets
- Resource limits and non-root containers

## Testing

Load testing with included loadgenerator:
```bash
kubectl apply -f k8s/deployments/loadgenerator.yaml
kubectl get hpa -w
```

Results are documented in LOAD_TEST.md.

## Security

Container images scanned with Trivy. IaC manifests validated for best practices. Security decisions and scan results in SECURITY.md.

Secrets are managed through Kubernetes secrets and environment variables. Do not commit passwords to the repository.

## Documentation

- [Helm chart](helm/README.md)
- [Helmfile](helmfile/README.md)
- [Security report](SECURITY.md)
- [Load test results](LOAD_TEST.md)

## Notes

Redis can be disabled by setting `redis.enabled=false` in values.yaml. Cartservice will use in-memory storage instead.

The Terraform state is local due to GCS backend issues during initial setup. For production, migrate to remote state.