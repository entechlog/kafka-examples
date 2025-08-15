# =============================================================================
# Dockerfile - Python Development Environment
# =============================================================================
FROM python:3.11-slim

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    g++ \
    librdkafka-dev \
    libpq-dev \
    curl \
    jq \
    vim \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Set working directory
WORKDIR /app

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Create directory structure
RUN mkdir -p python-examples data

# Default command - keep container running
CMD ["tail", "-f", "/dev/null"]