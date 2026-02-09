# syntax=docker/dockerfile:1

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
    -o frontend .

# Final stage - distroless static (smaller than scratch with SSL certs)
FROM gcr.io/distroless/static-debian12:nonroot

WORKDIR /app

# Copy binary and static assets
COPY --from=builder --chown=nonroot:nonroot /app/frontend /app/
COPY --from=builder --chown=nonroot:nonroot /app/templates /app/templates/
COPY --from=builder --chown=nonroot:nonroot /app/static /app/static/

USER nonroot

EXPOSE 8080

ENTRYPOINT ["/app/frontend"]