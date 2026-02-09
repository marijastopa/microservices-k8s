# Build stage
FROM python:3.12-slim AS builder

WORKDIR /app

# Copy requirements first for better layer caching
COPY requirements.txt .

# Install dependencies to user site-packages
RUN pip install --no-cache-dir --user -r requirements.txt

# Final stage - Google Distroless for minimal attack surface
FROM gcr.io/distroless/python3-debian12:nonroot

WORKDIR /app

# Copy installed packages from builder
COPY --from=builder --chown=nonroot:nonroot /root/.local /home/nonroot/.local

# Copy application code
COPY --chown=nonroot:nonroot *.py ./
COPY --chown=nonroot:nonroot templates/ ./templates/

# Set environment
ENV PATH=/home/nonroot/.local/bin:$PATH \
    PYTHONUNBUFFERED=1

EXPOSE 8080

USER nonroot

ENTRYPOINT ["python3", "email_server.py"]