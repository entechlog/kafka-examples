- [Kafka CLI Commands Reference](#kafka-cli-commands-reference)
  - [📋 Topic Management](#-topic-management)
  - [📤 Producer Commands](#-producer-commands)
  - [📥 Consumer Commands](#-consumer-commands)
  - [👥 Consumer Group Management](#-consumer-group-management)

# Kafka CLI Commands Reference

## 📋 Topic Management

```bash
# List all topics
docker exec kafka kafka-topics --bootstrap-server localhost:9092 --list

# Create topic
docker exec kafka kafka-topics --bootstrap-server localhost:9092 --create --topic my-topic --partitions 3 --replication-factor 1

# Create topic with custom config
docker exec kafka kafka-topics --bootstrap-server localhost:9092 --create --topic user-events --partitions 6 --replication-factor 1 --config retention.ms=604800000

# Describe topic
docker exec kafka kafka-topics --bootstrap-server localhost:9092 --describe --topic my-topic

# Alter topic configuration
docker exec kafka kafka-configs --bootstrap-server localhost:9092 --entity-type topics --entity-name my-topic --alter --add-config retention.ms=86400000

# Delete topic
docker exec kafka kafka-topics --bootstrap-server localhost:9092 --delete --topic my-topic
```

## 📤 Producer Commands

```bash
# Simple producer
docker exec -it kafka kafka-console-producer --bootstrap-server localhost:9092 --topic my-topic

# Producer with keys
docker exec -it kafka kafka-console-producer --bootstrap-server localhost:9092 --topic user-events --property "parse.key=true" --property "key.separator=:"

# Producer with headers
docker exec -it kafka kafka-console-producer --bootstrap-server localhost:9092 --topic my-topic --property "parse.headers=true" --property "headers.separator=,"
```

## 📥 Consumer Commands

```bash
# Simple consumer from beginning
docker exec -it kafka kafka-console-consumer --bootstrap-server localhost:9092 --topic my-topic --from-beginning

# Consumer with consumer group
docker exec -it kafka kafka-console-consumer --bootstrap-server localhost:9092 --topic user-events --group connect-postgres-sink-users

# Consumer showing keys and headers
docker exec -it kafka kafka-console-consumer --bootstrap-server localhost:9092 --topic user-events --from-beginning --property print.key=true --property print.headers=true --property key.separator=":"

# Consumer with offset and partition info
docker exec -it kafka kafka-console-consumer --bootstrap-server localhost:9092 --topic my-topic --from-beginning --property print.offset=true --property print.partition=true
```

## 👥 Consumer Group Management

```bash
# List consumer groups
docker exec kafka kafka-consumer-groups --bootstrap-server localhost:9092 --list

# Describe consumer group
docker exec kafka kafka-consumer-groups --bootstrap-server localhost:9092 --describe --group connect-postgres-sink-users

# Check consumer lag
docker exec kafka kafka-consumer-groups --bootstrap-server localhost:9092 --describe --group connect-postgres-sink-users --verbose

# Reset offsets to beginning
docker exec kafka kafka-consumer-groups --bootstrap-server localhost:9092 --group connect-postgres-sink-users --reset-offsets --to-earliest --topic my-topic --execute

# Reset offsets to end
docker exec kafka kafka-consumer-groups --bootstrap-server localhost:9092 --group connect-postgres-sink-users --reset-offsets --to-latest --topic my-topic --execute

# Reset to specific offset
docker exec kafka kafka-consumer-groups --bootstrap-server localhost:9092 --group connect-postgres-sink-users --reset-offsets --to-offset 100 --topic my-topic --execute

# Reset by timestamp
docker exec kafka kafka-consumer-groups --bootstrap-server localhost:9092 --group connect-postgres-sink-users --reset-offsets --to-datetime 2024-01-01T00:00:00.000 --topic my-topic --execute
```