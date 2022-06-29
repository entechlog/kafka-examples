- [Overview](#overview)
- [Aiven](#aiven)
- [MSK](#msk)
  
# Overview
Terraform template to create Kafka cluster with different managed service providers

# Aiven

- Bring up the kafka-tools container by running
  ```bash
  docker-compose up -d --build
  ```

- Create AWS profile by running
  ```bash
  aws configure --profile terraform
  ```

- Create resources by running   
  ```bash
  terraform apply
  ```

- Bring up the kafka-tools container by running
  ```bash
  docker-compose down -v --remove-orphans
  ```
  
# MSK

WIP, Connectors are failing with no error message. Need additional research as time permits