- [Python Examples Reference](#python-examples-reference)
  - [🚀 Getting Started](#-getting-started)
  - [📋 Running Examples](#-running-examples)
    - [Basic Producer and Consumer](#basic-producer-and-consumer)
    - [Useful Commands for Testing](#useful-commands-for-testing)
  - [🔧 Interactive Development](#-interactive-development)
    - [Available Environment Variables](#available-environment-variables)
  - [📚 Demo Flow](#-demo-flow)
    - [Basic Kafka Producer/Consumer Pattern](#basic-kafka-producerconsumer-pattern)
  - [🔍 Monitoring Your Examples](#-monitoring-your-examples)
  - [💡 Tips for Development](#-tips-for-development)
  - [🛠️ Custom Development](#️-custom-development)
  - [📊 Data Flow Verification](#-data-flow-verification)
  - [🔄 Troubleshooting](#-troubleshooting)

# Python Examples Reference

## 🚀 Getting Started

All Python examples are ready to run in the Docker environment. First, ensure your Kafka cluster is running:

```bash
# Start the environment
docker-compose up -d

# Wait for services to be ready (2-3 minutes)
docker-compose ps
```

## 📋 Running Examples

### Basic Producer and Consumer

```bash
# Example 1: Simple Producer
# Sends basic messages to a topic
docker exec python-dev python python-examples/01_simple_producer.py

# Example 2: Simple Consumer  
# Consumes messages from beginning
docker exec python-dev python python-examples/02_simple_consumer.py
```

### Useful Commands for Testing

```bash
# View messages using Kafka console consumer
docker exec kafka kafka-console-consumer --bootstrap-server localhost:9092 --topic my-first-topic --from-beginning --max-messages 10

# Reset consumer group to re-read messages
docker exec kafka kafka-consumer-groups --bootstrap-server localhost:9092 --group python-consumer-group --reset-offsets --to-earliest --topic my-first-topic --execute

# Check consumer group status
docker exec kafka kafka-consumer-groups --bootstrap-server localhost:9092 --group python-consumer-group --describe
```

## 🔧 Interactive Development

```bash
# Get an interactive Python shell
docker exec -it python-dev bash

# Inside the container, you can:
cd /app
python  # Start Python REPL
```

### Available Environment Variables

The Python environment has these variables pre-configured:

- `KAFKA_BOOTSTRAP_SERVERS`: `kafka:29092`
- `POSTGRES_HOST`: `postgres`
- `POSTGRES_DB`: `kafka_demo`
- `POSTGRES_USER`: `postgres`  
- `POSTGRES_PASSWORD`: `postgres`

## 📚 Demo Flow

### Basic Kafka Producer/Consumer Pattern

```bash
# Step 1: Start the consumer first (in one terminal)
docker exec python-dev python python-examples/02_simple_consumer.py

# Step 2: Run the producer (in another terminal) 
docker exec python-dev python python-examples/01_simple_producer.py

# You'll see messages flowing from producer to consumer in real-time!
```

## 🔍 Monitoring Your Examples

While running the Python examples, you can monitor them using:

- **Control Center**: http://localhost:9021
- **CLI Tools**: See [01-basic-commands.md](./01-basic-commands.md)
- **Container Logs**: `docker logs python-dev`

## 💡 Tips for Development

- **Start consumer before producer** - This way you see messages in real-time
- **Use different consumer group IDs** - To replay messages from the beginning
- **Check the topics** - Use Control Center or CLI to see your data
- **Experiment with changes** - Modify the examples and run them again

## 🛠️ Custom Development

Create your own examples:

```bash
# Edit files directly (they're mounted as volumes)
vim python-examples/my_custom_example.py

# Run your custom code
docker exec python-dev python python-examples/my_custom_example.py
```

## 📊 Data Flow Verification

After running the producer, verify data flow:

```bash
# Check if topics were created
docker exec kafka kafka-topics --bootstrap-server localhost:9092 --list

# View recent messages
docker exec kafka kafka-console-consumer --bootstrap-server localhost:9092 --topic my-first-topic --from-beginning --max-messages 5

# Check consumer group status
docker exec kafka kafka-consumer-groups --bootstrap-server localhost:9092 --describe --group python-consumer-group
```

## 🔄 Troubleshooting

**Consumer not showing messages?**
```bash
# Reset the consumer group offset
docker exec kafka kafka-consumer-groups --bootstrap-server localhost:9092 --group python-consumer-group --reset-offsets --to-earliest --topic my-first-topic --execute

# Or use a new consumer group by changing 'group.id' in the consumer code
```

**Want to replay messages?**
- Change the `group.id` in the consumer code to a new name
- Or reset offsets using the command above