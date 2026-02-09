# Build stage - Noble (Ubuntu) for gRPC tools compatibility
FROM mcr.microsoft.com/dotnet/sdk:10.0-noble AS builder

WORKDIR /app

# Copy csproj first for better caching
COPY cartservice.csproj .

# Restore dependencies
RUN dotnet restore -a x64

# Copy source code
COPY . .

# Build self-contained single file with trimming
RUN dotnet publish cartservice.csproj \
    -c Release \
    -a x64 \
    --self-contained true \
    -p:PublishSingleFile=true \
    -p:PublishTrimmed=true \
    -p:TrimMode=full \
    -o /app/out

# Final stage
FROM mcr.microsoft.com/dotnet/runtime-deps:10.0-noble-chiseled

WORKDIR /app

# Copy published binary
COPY --from=builder /app/out/cartservice .

# Environment variables
ENV DOTNET_EnableDiagnostics=0 \
    ASPNETCORE_HTTP_PORTS=7070

EXPOSE 7070

USER 1000

ENTRYPOINT ["/app/cartservice"]