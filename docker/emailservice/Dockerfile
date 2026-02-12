# Build stage
FROM python:3.12-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# Final stage - slim instead of distroless
FROM python:3.12-slim
WORKDIR /app

# Create non-root user
RUN useradd -m -u 1000 appuser

# Copy installed packages from builder
COPY --from=builder --chown=appuser:appuser /root/.local /home/appuser/.local

# Copy application code
COPY --chown=appuser:appuser *.py ./
COPY --chown=appuser:appuser templates/ ./templates/

# Set environment
ENV PATH=/home/appuser/.local/bin:$PATH \
    PYTHONUNBUFFERED=1

USER appuser

EXPOSE 8080

ENTRYPOINT ["python3", "email_server.py"]