# Build stage - Noble (Ubuntu) for protoc compatibility
FROM eclipse-temurin:24-jdk-noble AS builder

WORKDIR /app

# Copy Gradle files first for better caching
COPY build.gradle gradlew settings.gradle ./
COPY gradle gradle/

# Make gradlew executable and download dependencies
RUN chmod +x gradlew && \
    ./gradlew downloadRepos

# Copy source code
COPY . .

# Build the application
RUN chmod +x gradlew && \
    ./gradlew installDist

# Final stage - JRE Alpine for minimal size
FROM eclipse-temurin:25-jre-alpine

WORKDIR /app

# Create non-root user
RUN addgroup -S appuser && adduser -S appuser -G appuser

# Copy built application
COPY --from=builder --chown=appuser:appuser /app/build/install/hipstershop ./

USER appuser

EXPOSE 9555

ENTRYPOINT ["/app/bin/AdService"]