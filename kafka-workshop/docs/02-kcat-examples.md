- [kcat (kafkacat) Examples](#kcat-kafkacat-examples)
  - [🔍 Cluster Information](#-cluster-information)
  - [📤 Producer Examples](#-producer-examples)
  - [📥 Consumer Examples](#-consumer-examples)
  - [🚀 Advanced Examples](#-advanced-examples)

# kcat (kafkacat) Examples

## 🔍 Cluster Information

```bash
# Show cluster metadata (brokers, topics, partitions)
docker exec kcat kcat -b kafka:29092 -L

# Show specific topic metadata
docker exec kcat kcat -b kafka:29092 -L -t my-topic

# Query partition offsets
docker exec kcat kcat -b kafka:29092 -t my-topic -Q
```

## 📤 Producer Examples

```bash
# Simple producer
echo "Hello Kafka" | docker exec -i kcat kcat -b kafka:29092 -t my-topic -P

# Producer with key
echo "user1:login event" | docker exec -i kcat kcat -b kafka:29092 -t user-events -P -K:

# Producer with headers
echo "Hello with headers" | docker exec -i kcat kcat -b kafka:29092 -t my-topic -P -H source=demo -H version=1.0

# Producer with specific partition
echo "Message to partition 2" | docker exec -i kcat kcat -b kafka:29092 -t my-topic -P -p 2

# Produce JSON from file
cat data/sample-events.json | docker exec -i kcat kcat -b kafka:29092 -t events -P

# Produce multiple messages with delay
for i in {1..10}; do 
  echo "Message $i" | docker exec -i kcat kcat -b kafka:29092 -t my-topic -P
  sleep 1
done
```

## 📥 Consumer Examples

```bash
# Simple consumer
docker exec kcat kcat -b kafka:29092 -t my-topic -C

# Consumer from beginning
docker exec kcat kcat -b kafka:29092 -t my-topic -C -o beginning

# Consumer with custom formatting
docker exec kcat kcat -b kafka:29092 -t my-topic -C -f 'Partition: %p | Offset: %o | Key: %k | Value: %s\n'

# Consumer showing headers
docker exec kcat kcat -b kafka:29092 -t my-topic -C -f 'Headers: %h | Key: %k | Value: %s\n'

# Consumer with timestamp
docker exec kcat kcat -b kafka:29092 -t my-topic -C -f 'Time: %T | Partition: %p | Offset: %o | Value: %s\n'

# Consume specific number of messages
docker exec kcat kcat -b kafka:29092 -t my-topic -C -c 10

# Consume from specific partition
docker exec kcat kcat -b kafka:29092 -t my-topic -C -p 0

# Consume from specific offset
docker exec kcat kcat -b kafka:29092 -t my-topic -C -p 0 -o 100

# Consumer with JSON pretty print
docker exec kcat kcat -b kafka:29092 -t events -C -f '%s\n' | jq '.'
```

## 🚀 Advanced Examples

```bash
# Copy messages between topics
docker exec kcat kcat -b kafka:29092 -t source-topic -C -e | docker exec -i kcat kcat -b kafka:29092 -t dest-topic -P

# Monitor consumer lag in real-time
watch 'docker exec kcat kcat -b kafka:29092 -Q -t my-topic'

# Produce with timestamp
echo "timestamped message" | docker exec -i kcat kcat -b kafka:29092 -t my-topic -P -T

# Consumer with group
docker exec kcat kcat -b kafka:29092 -t my-topic -C -G my-group

# Tail mode (like tail -f)
docker exec kcat kcat -b kafka:29092 -t my-topic -C -o end
```