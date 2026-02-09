# Build stage
FROM node:20-alpine AS builder

WORKDIR /app

# Install build dependencies for native modules (pprof)
RUN apk add --update --no-cache \
    python3 \
    make \
    g++

# Copy package files first for better caching
COPY package*.json ./

# Install production dependencies
RUN npm ci --only=production

# Final stage - Alpine for Node.js compatibility
FROM alpine:3.23

# Install Node.js runtime only
RUN apk add --no-cache nodejs

WORKDIR /app

# Create non-root user
RUN addgroup -S appuser && adduser -S appuser -G appuser

# Copy dependencies and application
COPY --from=builder --chown=appuser:appuser /app/node_modules ./node_modules
COPY --chown=appuser:appuser package*.json ./
COPY --chown=appuser:appuser server.js ./
COPY --chown=appuser:appuser proto/ ./proto/
COPY --chown=appuser:appuser data/ ./data/

USER appuser

EXPOSE 7000

CMD ["node", "server.js"]