# Dockerfile
FROM python:3.9-slim-buster

# Install Java
COPY --from=openjdk:8-jre-slim /usr/local/openjdk-8 /usr/local/openjdk-8
ENV JAVA_HOME /usr/local/openjdk-8
RUN update-alternatives --install /usr/bin/java java /usr/local/openjdk-8/bin/java 1

WORKDIR /usr/app

# Install Linux Packages
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    wget \
    snapd \
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
    ca-certificates && \
    apt-get purge -y --auto-remove

RUN apt install -y build-essential

# Install Kafka Binary
RUN curl "https://dlcdn.apache.org/kafka/3.1.0/kafka_2.12-3.1.0.tgz" -o /tmp/kafka.tgz
RUN mkdir /kafka
RUN tar -xvzf /tmp/kafka.tgz --directory /kafka --strip-components 1
RUN rm -f /tmp/kafka.tgz

# Install Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Install Kafka Topic Analyzer
ENV USER=root
RUN cargo install kafka-topic-analyzer
RUN cp /root/.cargo/bin/kafka-topic-analyzer /usr/bin
RUN chmod 755 /usr/bin/kafka-topic-analyzer

# Install Python packages
COPY requirements.txt ./
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Install teraform
RUN wget -qO - terraform.gpg https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/terraform-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/terraform-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" > /etc/apt/sources.list.d/terraform.list
RUN apt update
RUN apt install terraform

# Install Java
RUN apt install -y default-jre
RUN apt install -y default-jdk

# Create ubuntu user 
RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1001 ubuntu 
USER ubuntu
WORKDIR /home/ubuntu