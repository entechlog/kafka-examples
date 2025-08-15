- [Load Testing Commands](#load-testing-commands)
  - [🚀 Built-in Kafka Performance Tools](#-built-in-kafka-performance-tools)
    - [Producer Performance Test](#producer-performance-test)
    - [Consumer Performance Test](#consumer-performance-test)
  - [📊 kcat Load Testing](#-kcat-load-testing)
  - [🔥 Stress Testing Scenarios](#-stress-testing-scenarios)
    - [Scenario 1: High Message Rate](#scenario-1-high-message-rate)
    - [Scenario 2: Large Message Test](#scenario-2-large-message-test)
    - [Scenario 3: Consumer Group Rebalancing](#scenario-3-consumer-group-rebalancing)
  - [📈 Monitoring During Load Tests](#-monitoring-during-load-tests)

# Load Testing Commands

## 🚀 Built-in Kafka Performance Tools

### Producer Performance Test
```bash
# Test producer throughput
docker exec kafka kafka-producer-perf-test \
  --topic load-test-topic \
  --num-records 100000 \
  --record-size 1000 \
  --throughput 10000 \
  --producer-props bootstrap.servers=localhost:9092

# High throughput test
docker exec kafka kafka-producer-perf-test \
  --topic load-test-topic \
  --num-records 1000000 \
  --record-size 100 \
  --throughput -1 \
  --producer-props bootstrap.servers=localhost:9092 acks=1 batch.size=32768 linger.ms=10

# Test with different configurations
docker exec kafka kafka-producer-perf-test \
  --topic load-test-topic \
  --num-records 50000 \
  --record-size 500 \
  --throughput 5000 \
  --producer-props bootstrap.servers=localhost:9092 acks=all retries=3 enable.idempotence=true
```

### Consumer Performance Test
```bash
# Test consumer throughput
docker exec kafka kafka-consumer-perf-test \
  --topic load-test-topic \
  --messages 100000 \
  --threads 1 \
  --bootstrap-server localhost:9092

# Multi-threaded consumer test
docker exec kafka kafka-consumer-perf-test \
  --topic load-test-topic \
  --messages 1000000 \
  --threads 4 \
  --bootstrap-server localhost:9092 \
  --group load-test-group
```

## 📊 kcat Load Testing

```bash
# Generate continuous load with kcat
seq 1 10000 | docker exec -i kcat kcat -b kafka:29092 -t load-test-topic -P

# Load test with realistic data
for i in {1..1000}; do
  echo "{\"user_id\":\"user-$((RANDOM % 1000))\",\"event\":\"click\",\"timestamp\":\"$(date -Iseconds)\",\"data\":\"test-data-$i\"}" | \
  docker exec -i kcat kcat -b kafka:29092 -t user-events -P -K:
done

# Parallel producers
for i in {1..5}; do
  (seq 1 1000 | docker exec -i kcat kcat -b kafka:29092 -t load-test-topic -P) &
done
wait

# Measure consumption rate
time docker exec kcat kcat -b kafka:29092 -t load-test-topic -C -e | wc -l
```

## 🔥 Stress Testing Scenarios

### Scenario 1: High Message Rate
```bash
# Create topic optimized for throughput
docker exec kafka kafka-topics --bootstrap-server localhost:9092 --create --topic high-throughput --partitions 12 --replication-factor 1 --config segment.ms=10000

# Producer stress test
docker exec kafka kafka-producer-perf-test \
  --topic high-throughput \
  --num-records 5000000 \
  --record-size 100 \
  --throughput -1 \
  --producer-props bootstrap.servers=localhost:9092 acks=1 batch.size=65536 linger.ms=20 compression.type=gzip
```

### Scenario 2: Large Message Test
```bash
# Create topic for large messages
docker exec kafka kafka-topics --bootstrap-server localhost:9092 --create --topic large-messages --partitions 6 --replication-factor 1 --config max.message.bytes=10485760

# Test with large messages
docker exec kafka kafka-producer-perf-test \
  --topic large-messages \
  --num-records 10000 \
  --record-size 1048576 \
  --throughput 100 \
  --producer-props bootstrap.servers=localhost:9092 max.request.size=10485760
```

### Scenario 3: Consumer Group Rebalancing
```bash
# Start multiple consumers and add/remove them
# Terminal 1
docker exec -it kafka kafka-console-consumer --bootstrap-server localhost:9092 --topic user-events --group rebalance-test &

# Terminal 2 (add after 30 seconds)
docker exec -it kafka kafka-console-consumer --bootstrap-server localhost:9092 --topic user-events --group rebalance-test &

# Terminal 3 (add after another 30 seconds)
docker exec -it kafka kafka-console-consumer --bootstrap-server localhost:9092 --topic user-events --group rebalance-test &

# Monitor rebalancing
watch 'docker exec kafka kafka-consumer-groups --bootstrap-server localhost:9092 --describe --group rebalance-test'
```

## 📈 Monitoring During Load Tests

```bash
# Monitor topic during load test
watch 'docker exec kafka kafka-run-class kafka.tools.GetOffsetShell --broker-list localhost:9092 --topic load-test-topic'

# Monitor consumer lag
watch 'docker exec kafka kafka-consumer-groups --bootstrap-server localhost:9092 --describe --group load-test-group'

# Monitor JVM metrics (if JMX enabled)
docker exec kafka jconsole

# Monitor with kcat
watch 'docker exec kcat kcat -b kafka:29092 -Q'
```