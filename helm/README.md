# Microservices Helm Chart

Helm chart for deploying a microservices e-commerce application on GKE.

## Installation
```bash
helm install microservices ./microservices
```

## Configuration

Edit `microservices/values.yaml` to customize:

- Image registry and tags
- Replica counts
- Resource limits
- HPA settings
- Environment variables

## Deployed Services

- frontend (LoadBalancer)
- checkoutservice
- recommendationservice
- productcatalogservice
- cartservice
- currencyservice
- paymentservice
- shippingservice
- emailservice
- adservice

## HPA Configuration

HPA is enabled for:
- frontend (1-5 replicas, 50% CPU)
- checkoutservice (2-10 replicas, 60% CPU)
- recommendationservice (1-5 replicas, 70% CPU)

## Upgrade
```bash
helm upgrade microservices ./microservices
```

## Uninstall
```bash
helm uninstall microservices
```