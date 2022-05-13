- [Overview](#overview)
- [Instructions](#instructions)
- [Tools in this container](#tools-in-this-container)
  - [kcat(formerly known as as kafkacat)](#kcatformerly-known-as-as-kafkacat)
  - [Kafka](#kafka)
  - [Kafka Topic Analyzer](#kafka-topic-analyzer)
  
# Overview
kafka tools container contains contains software's which helps to work with a kafka cluster.

# Instructions
- Bring up the kafka-tools container by running
  ```bash
  docker-compose up -d --build
  ```
- Bring up the kafka-tools container by running
  ```bash
  docker-compose down -v --remove-orphans
  ```

# Tools in this container

## kcat(formerly known as as kafkacat)

```bash
## List all brokers
kafkacat -L -b 192.168.0.101:30020 | grep broker
```

## Kafka

```bash
## List all brokers
./kafka-broker-api-versions.sh --bootstrap-server 192.168.0.101:30020 | awk '/id/{print $1}'
```

## Kafka Topic Analyzer

```bash
kafka-topic-analyzer --bootstrap-server 192.168.0.101:30020 --topic __consumer_offsets
```

