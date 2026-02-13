# Microservices Helm Chart

Helm chart for deploying a microservices e-commerce application on GKE.

## Dependencies

This chart includes Redis as a dependency (subchart):
- Redis 25.2.0 from Bitnami
- Automatically deployed when `redis.enabled=true`

## Installation
```bash
# Download dependencies first
helm dependency update ./microservices

# Install with Redis
helm install microservices ./microservices \
  --set redis.auth.password=$REDIS_PASSWORD

# Install without Redis (in-memory cart)
helm install microservices ./microservices \
  --set redis.enabled=false
```

## Configuration

Edit `microservices/values.yaml` to customize:

- Image registry and tags
- Replica counts
- Resource limits
- HPA settings
- Redis configuration (as subchart)

## Deployed Services

- frontend (LoadBalancer)
- checkoutservice
- recommendationservice
- productcatalogservice
- cartservice (uses Redis when enabled)
- currencyservice
- paymentservice
- shippingservice
- emailservice
- adservice

## Redis Subchart

Redis is managed as a Helm dependency:
- Condition: `redis.enabled` (default: true)
- Password: Must be provided via `--set redis.auth.password=xxx`
- Cartservice automatically connects when Redis is enabled

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