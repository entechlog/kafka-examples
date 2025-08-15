FROM python:3.9-slim-buster

# Install Java
COPY --from=openjdk:8-jre-slim /usr/local/openjdk-8 /usr/local/openjdk-8
ENV JAVA_HOME /usr/local/openjdk-8
RUN update-alternatives --install /usr/bin/java java /usr/local/openjdk-8/bin/java 1

WORKDIR /usr/app

# Set environment variable to avoid debconf warnings
ENV DEBIAN_FRONTEND=noninteractive

# Install Linux Packages
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    wget \
    git \
    curl \
    sshpass \
    openssh-server \ 
    sudo \
    nmap \
    gnupg \
    kafkacat \
    lsb-release \ 
    alien \
    apt-transport-https \
    ca-certificates \
    unzip \
    build-essential \
    default-jre \
    default-jdk && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Kafka Binary
ENV KAFKA_VERSION=4.0.0
ENV SCALA_VERSION=2.13
ENV KAFKA_HOME=/kafka

RUN curl -fsSL "https://dlcdn.apache.org/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz" -o /tmp/kafka.tgz \
 && mkdir -p ${KAFKA_HOME} \
 && tar -xzf /tmp/kafka.tgz --directory ${KAFKA_HOME} --strip-components 1 \
 && rm -f /tmp/kafka.tgz

# Install Rust
RUN curl -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Install Kafka Topic Analyzer
ENV USER=root
RUN cargo install kafka-topic-analyzer && \
    cp /root/.cargo/bin/kafka-topic-analyzer /usr/bin && \
    chmod 755 /usr/bin/kafka-topic-analyzer

# Install Python packages
COPY requirements.txt ./
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Install Terraform directly from binary
ENV TERRAFORM_VERSION=1.11.2
RUN curl -fsSL "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -o /tmp/terraform.zip \
    && unzip /tmp/terraform.zip -d /usr/local/bin \
    && rm /tmp/terraform.zip \
    && chmod +x /usr/local/bin/terraform

# Create ubuntu user 
RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1001 ubuntu && \
    echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER ubuntu
WORKDIR /home/ubuntu