- [Overview](#overview)
  - [Kafka](#kafka)
  - [Kafka Terminology](#kafka-terminology)
  - [Kafka Components](#kafka-components)
- [Demo](#demo)
  - [Start docker containers](#start-docker-containers)
  - [Kafka Broker](#kafka-broker)
  - [Kafka Producer](#kafka-producer)
  - [Kafka Stream Processsing (ksqlDB)](#kafka-stream-processsing-ksqldb)
  - [Kafka Consumer](#kafka-consumer)
  - [Create Superset Dashboard](#create-superset-dashboard)
  - [Clean demo resources](#clean-demo-resources)
- [Reference](#reference)
- [Notes](#notes)

# Overview

Welcome to your kafka demo workshop. In this demo we will try to cover the basics of kafka and will create an streaming elt pipline using ksqlDB.

<p align="center">
  <img src="./docs/images/demo-overview.png" alt="Kafka Demo Overview" width="738">
</p>

## Kafka

- Apache Kafka is an distributed event streaming platform optimized for ingesting and processing streaming data in real-time.
- LinkedIn developed Kafka in 2011 as a high-throughput message broker for its own use, then open-sourced and donated Kafka to the Apache Software Foundation

## Kafka Terminology

| Term               | Description                                                                                                                                                                                                 |
| ------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Events             | An event represents a fact that happened in the past. Events are immutable                                                                                                                                  |
| Streams            | Events in motion                                                                                                                                                                                            |
| Topics             | Topic is a materialized event stream                                                                                                                                                                        |
| Partitions         | Partition is the smallest storage unit that holds a subset of records owned by a topic. Each partition is a single log file where records are written to it in an append-only fashion                       |
| Offsets            | The records in the partitions are each assigned a sequential identifier called the offset. Messages within a partition are ordered, messages across a topic are not guaranteed to be ordered                |
| Broker             | A broker is an instance (server, computer, container) running Kakfa process. Manage partitions, handles read write requests, manage replication of partitions                                               |
| Zookeeper          | Kafka uses ZooKeeper to store its metadata. Data such as the location of partitions and the configuration of topics are stored outside of Kafka in ZooKeeper                                                |
| Producers          | Producers are processes that push records into Kafka topics                                                                                                                                                 |
| Consumers          | Consumers are processes that pulls records into Kafka topics                                                                                                                                                |
| Replication factor | The replication factor controls how many servers will replicate each message that is written. If you have a replication factor of 3, then up to 2 servers can fail before you will lose access to your data |
| Controller         | Kafka elects one broker in the cluster to be the controller. The controller is responsible for cluster management and handles events like broker failures, leader election, topic deletion and more.        |

## Kafka Components

<p align="center">
  <img src="./docs/images/kafka-components.png" alt="Kafka Components" width="738">
</p>

# Demo

## Start docker containers

> **🛑 Please stop any existing containers before proceeding to next steps 🛑**

- Clone this repo

- Open an new terminal and cd into `kafka-postgres-superset` directory. This directory contains infra components for this demo

- Create a copy of [`.env.template`](./dbt-docker/../../dbt-docker/.env.template) as `.env`
- Start Kafka containers by running

  ```bash
  docker-compose up --remove-orphans -d --build
  ```

- Validate the container by running

  ```bash
  docker ps
  ```

- Navigate to [Control Center](http://localhost:9021/clusters) in your browser
- Navigate to [pgAdmin](http://localhost:5050/) in your browser and login with `admin@admin.com` and `postgres`

- Click on Add New Server and give following details

  - Name : kafka demo
  - Host Name : postgres
  - User : postgres
  - Password : postgres

- Navigate to [Superset](http://localhost:8044/) in your browser and login with `admin` and `admin`

> ⚠️ If you change the credentials in `.env` the please make to use them ⚠️

## Kafka Broker

Validate the Kafka Broker by running

```bash
docker exec -it kafkacat kafkacat -b broker:9092 -L
```

## Kafka Producer

- Produce sample messages to demo topic by running

```bash
docker exec -it kafkacat kafkacat -b broker:9092 -t demo -P -K~
1~Iron Man
2~Ant Man
3~Spider Man
4~Avengers
```

- We will produce more message using Kafka connector and Datagen.

```json
{
  "name": "datagen-users",
  "config": {
    "connector.class": "io.confluent.kafka.connect.datagen.DatagenConnector",
    "kafka.topic": "users",
    "quickstart": "users",
    "key.converter": "org.apache.kafka.connect.storage.StringConverter",
    "value.converter": "io.confluent.connect.avro.AvroConverter",
    "value.converter.schema.registry.url": "http://schema-registry:8081",
    "value.converter.schemas.enable": "false",
    "max.interval": 30000,
    "iterations": -1,
    "tasks.max": "1"
  }
}
```

## Kafka Stream Processsing (ksqlDB)

- Start ksqlDB’s CLI using the command
  `docker exec -it ksqldb-cli ksql http://ksqldb-server:8088`

- Create stream process by running below sql

```sql
SET 'auto.offset.reset' = 'earliest';

-- Create RAW Stream
CREATE
	OR REPLACE STREAM STM_USER_0010_RAW (ROWKEY VARCHAR KEY)
	WITH (
			KAFKA_TOPIC = 'users'
			,VALUE_FORMAT = 'AVRO'
			);

-- Create table to count users
CREATE
	OR REPLACE TABLE TBL_USER_0020_GENDER_COUNT AS

SELECT GENDER, AS_VALUE(GENDER) AS GENDER_KEY, COUNT(GENDER) AS GENDER_COUNT
FROM STM_USER_0010_RAW
GROUP BY GENDER EMIT CHANGES;
```

## Kafka Consumer

- Consume messages from demo topic by running

```bash
docker exec -it kafkacat kafkacat -b broker:9092 -t demo -C -o beginning

docker exec -it kafkacat kafkacat -b broker:9092 -t demo -C -o 3

docker exec -it kafkacat kafkacat -b broker:9092 -t demo -o beginning -f 'Topic %t[%p], offset: %o, key: %k, payload: %S bytes: %s\n'

docker exec -it kafkacat kafkacat -b broker:9092 -t demo -o 3 -f 'Topic %t[%p], offset: %o, key: %k, payload: %S bytes: %s\n'
```

- We will consume message using Kafka connector

```json
{
  "name": "postgres-sink-users-gender",
  "config": {
    "value.converter.schema.registry.url": "http://schema-registry:8081",
    "connector.class": "io.confluent.connect.jdbc.JdbcSinkConnector",
    "key.converter": "org.apache.kafka.connect.storage.StringConverter",
    "value.converter": "io.confluent.connect.avro.AvroConverter",
    "value.converter.schemas.enable": "false",
    "topics": "TBL_USER_0020_GENDER_COUNT",
    "connection.url": "jdbc:postgresql://postgres:5432/",
    "connection.user": "postgres",
    "connection.password": "postgres",
    "insert.mode": "upsert",
    "delete.enabled": true,
    "table.name.format": "demo.users_gender_count",
    "pk.mode": "record_key",
    "pk.fields": "gender_key",
    "auto.create": "true"
  }
}
```

## Create Superset Dashboard

- Create database
  `postgresql://postgres:postgres@postgres:5432/postgres`
- Create dataset
- Create chart and add to dashboard

<p align="center">
  <img src="./docs/images/sample-dashboard.jpg" alt="Sample Dashboard" width="738">
</p>

## Clean demo resources

- Exit ksqlDB cli by running `exit`
- Open an new terminal and cd into `kafka-postgres-superset` directory.
- Run below command to delete the docker containers and related volumes `docker-compose down --volumes --remove-orphans`

- Delete exited containers by running `docker rm $(docker ps -q -f status=exited)`

# Reference

- https://kb.objectrocket.com/postgresql/how-to-create-postgresql-test-data-1138
- https://gist.github.com/onjin/2dd3cc52ef79069de1faa2dfd456c945
- https://rmoff.net/2017/09/06/kafka-connect-jsondeserializer-with-schemas.enable-requires-schema-and-payload-fields/
- Config files for this example was sourced from https://github.com/confluentinc/kafka-connect-datagen/tree/master/config
- https://docs.cloudera.com/runtime/7.2.10/kafka-overview/topics/kafka-overview-architecture.html
- https://medium.com/event-driven-utopia/understanding-kafka-topic-partitions-ae40f80552e8

# Notes

- dos2unix
  `find . -type f -print0 | xargs -0 -n 1 -P 4 dos2unix`
- git
  `git config --global core.autocrlf true`