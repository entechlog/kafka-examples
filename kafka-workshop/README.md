# Apache Kafka Workshop

Welcome to the Kafka workshop — from fundamentals to production-ready streaming apps.

## 🎯 What You'll Learn
- Kafka fundamentals & architecture
- CLI basics
- Python producers & consumers
- Kafka Connect & integrations
- Stream processing with ksqlDB
- Monitoring & production best practices

## 🛠 Workshop Setup

**Prerequisites**
- Docker + Docker Compose
- Basic command-line familiarity

**Quick Start**
```bash
git clone https://github.com/entechlog/kafka-examples
cd kafka-workshop

# Start the complete environment
docker-compose up -d

# Wait 2-3 minutes for everything to start
docker-compose ps

# Get a shell inside the kafka-connect container
docker exec -it kafka-connect bash

# Check what files you have
ls -la /tmp/connectors/

# Use the postgres sink
curl -X POST \
  -H "Content-Type: application/json" \
  --data @/tmp/connectors/postgres-sink-users.json \
  http://localhost:8083/connectors

# Check if it was created
curl -s http://localhost:8083/connectors

# Check status
curl -s http://localhost:8083/connectors/postgres-sink-users/status

# Bring down container
docker-compose down -v

# Remove old images
docker system prune -f
```

**Services**
| Tool           | URL                        |
| -------------- | -------------------------- |
| Control Center | http://localhost:9021      |
| pgAdmin        | http://localhost:5050      |
| Kafka Connect  | http://localhost:8083      |
| ksqlDB Server  | http://localhost:8088      |

## 📁 Workshop Materials
- [01-basic-commands.md](./docs/01-basic-commands.md)
- [02-kcat-examples.md](./docs/02-kcat-examples.md)
- [03-python-examples.md](./docs/03-python-examples.md)
- [04-load-test-commands.md](./docs/04-load-test-commands.md)

---

*Happy streaming!* 🚀
