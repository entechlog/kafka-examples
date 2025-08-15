#!/bin/bash

echo "🎬 Creating demo data for workshop videos..."

# Create topics for each video
echo "📝 Creating topics..."

# Video 1 topics
docker exec kafka kafka-topics --bootstrap-server localhost:9092 --create --topic my-first-topic --partitions 3 --replication-factor 1 --if-not-exists

# Video 2 topics  
docker exec kafka kafka-topics --bootstrap-server localhost:9092 --create --topic user-events --partitions 6 --replication-factor 1 --if-not-exists

# Video 3 topics (Connect will create these)
docker exec kafka kafka-topics --bootstrap-server localhost:9092 --create --topic users --partitions 3 --replication-factor 1 --if-not-exists

# Video 4 topics
docker exec kafka kafka-topics --bootstrap-server localhost:9092 --create --topic orders --partitions 4 --replication-factor 1 --if-not-exists
docker exec kafka kafka-topics --bootstrap-server localhost:9092 --create --topic page-views --partitions 6 --replication-factor 1 --if-not-exists

# Load test topics
docker exec kafka kafka-topics --bootstrap-server localhost:9092 --create --topic load-test-topic --partitions 12 --replication-factor 1 --if-not-exists

echo "📤 Generating sample data..."

# Generate some initial data for demonstrations
for i in {1..20}; do
  echo "Message $i from demo script" | docker exec -i kcat kcat -b kafka:29092 -t my-first-topic -P
done

# Generate user events with keys
for i in {1..50}; do
  user="user-$((i % 10))"
  action=("login" "logout" "purchase" "view")
  selected_action=${action[$((RANDOM % 4))]}
  echo "$user:{\"user_id\":\"$user\",\"action\":\"$selected_action\",\"timestamp\":\"$(date -Iseconds)\"}" | \
    docker exec -i kcat kcat -b kafka:29092 -t user-events -P -K:
done

echo "✅ Demo data created!"
echo "🎯 Ready for video recording!"