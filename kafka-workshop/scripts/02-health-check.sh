#!/bin/bash

echo "🏥 Kafka Workshop Health Check"
echo "=============================="

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

check_service() {
    local service=$1
    local url=$2
    local name=$3
    
    if curl -s "$url" > /dev/null 2>&1; then
        echo -e "✅ ${GREEN}$name${NC} - OK"
        return 0
    else
        echo -e "❌ ${RED}$name${NC} - FAILED"
        return 1
    fi
}

echo "🔍 Checking services..."

# Check Kafka
if docker exec kafka kafka-broker-api-versions --bootstrap-server localhost:9092 > /dev/null 2>&1; then
    echo -e "✅ ${GREEN}Kafka Broker${NC} - OK"
else
    echo -e "❌ ${RED}Kafka Broker${NC} - FAILED"
fi

# Check other services
check_service "schema-registry" "http://localhost:8081" "Schema Registry"
check_service "kafka-connect" "http://localhost:8083" "Kafka Connect"
check_service "control-center" "http://localhost:9021" "Control Center"
check_service "pgadmin" "http://localhost:5050" "pgAdmin"

# Check PostgreSQL
if docker exec postgres pg_isready -U postgres > /dev/null 2>&1; then
    echo -e "✅ ${GREEN}PostgreSQL${NC} - OK"
else
    echo -e "❌ ${RED}PostgreSQL${NC} - FAILED"
fi

# Check topics
echo -e "\n📋 Topics:"
docker exec kafka kafka-topics --bootstrap-server localhost:9092 --list

# Check connectors
echo -e "\n🔌 Connectors:"
curl -s http://localhost:8083/connectors 2>/dev/null | jq -r '.[]' 2>/dev/null || echo "No connectors or Connect not ready"

echo -e "\n✅ Health check complete!"