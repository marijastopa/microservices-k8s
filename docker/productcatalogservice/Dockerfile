# Build stage
FROM golang:1.25-alpine AS builder

WORKDIR /app

# Copy go mod files first for better caching
COPY go.mod go.sum ./
RUN go mod download

# Copy source code
COPY . .

# Build static binary
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build \
    -ldflags='-w -s -extldflags "-static"' \
    -o productcatalogservice .

# Final stage - distroless static
FROM gcr.io/distroless/static-debian12:nonroot

WORKDIR /app

# Copy binary and product data
COPY --from=builder --chown=nonroot:nonroot /app/productcatalogservice /app/
COPY --chown=nonroot:nonroot products.json /app/

USER nonroot

EXPOSE 3550

ENTRYPOINT ["/app/productcatalogservice"]