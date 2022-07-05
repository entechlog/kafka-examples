- [Overview](#overview)
- [Aiven](#aiven)
- [MSK](#msk)
- [References](#references)
  - [Terraform for MSK cluster](#terraform-for-msk-cluster)
  
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

# References
## Terraform for MSK cluster
- https://github.com/vinamra1502/terraform-work/tree/main/terraform-module/msk
- https://github.com/msfidelis/aws-msk-glue-kafka-setup
- https://www.davidc.net/sites/default/subnets/subnets.html
- https://search.maven.org/artifact/org.mongodb.kafka/mongo-kafka-connect/1.7.0/jar
- https://repo1.maven.org/maven2/com/snowflake/snowflake-kafka-connector/1.8.0/
- https://medium.com/appgambit/terraform-aws-vpc-with-private-public-subnets-with-nat-4094ad2ab331
- https://aws.amazon.com/blogs/apn/connecting-applications-securely-to-a-mongodb-atlas-data-plane-with-aws-privatelink/
- https://docs.aws.amazon.com/msk/latest/developerguide/msk-connect-internet-access.html