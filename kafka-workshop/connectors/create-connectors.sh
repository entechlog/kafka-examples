#!/bin/bash
# connectors/create-connectors.sh

set -e

CONNECT_URL="http://kafka-connect:8083"
CONNECTORS_DIR="/tmp/connectors"

echo "🔧 Waiting for Kafka Connect to be ready..."

# Wait for Kafka Connect to be ready
while true; do
    if curl -s "$CONNECT_URL/connectors" > /dev/null 2>&1; then
        echo "✅ Kafka Connect is ready!"
        break
    else
        echo "⏳ Kafka Connect not ready yet, waiting 5 seconds..."
        sleep 5
    fi
done

# Function to create connector
create_connector() {
    local config_file=$1
    local connector_name=$(basename "$config_file" .json)
    
    echo "📝 Creating connector: $connector_name"
    
    # Check if connector already exists
    if curl -s "$CONNECT_URL/connectors/$connector_name" > /dev/null 2>&1; then
        echo "⚠️  Connector $connector_name already exists, deleting first..."
        curl -X DELETE "$CONNECT_URL/connectors/$connector_name"
        sleep 2
    fi
    
    # Create the connector
    response=$(curl -s -X POST \
        -H "Content-Type: application/json" \
        --data @"$config_file" \
        "$CONNECT_URL/connectors" \
        -w "HTTP_STATUS:%{http_code}")
    
    http_code=$(echo "$response" | grep -o "HTTP_STATUS:[0-9]*" | cut -d: -f2)
    response_body=$(echo "$response" | sed 's/HTTP_STATUS:[0-9]*$//')
    
    if [ "$http_code" -eq 201 ] || [ "$http_code" -eq 200 ]; then
        echo "✅ Connector $connector_name created successfully!"
        echo "$response_body"
    else
        echo "❌ Failed to create connector $connector_name (HTTP $http_code)"
        echo "$response_body"
        return 1
    fi
    
    echo ""
}

# Create all connectors
echo "🚀 Creating connectors from $CONNECTORS_DIR..."

for config_file in "$CONNECTORS_DIR"/*.json; do
    if [ -f "$config_file" ]; then
        create_connector "$config_file"
    fi
done

echo "🎉 Connector creation process completed!"

# Show final status
echo "📊 Current connectors:"
curl -s "$CONNECT_URL/connectors"

echo ""
echo "📈 Connector status:"
connectors=$(curl -s "$CONNECT_URL/connectors" | sed 's/\[//g; s/\]//g; s/"//g' | tr ',' '\n')
for connector in $connectors; do
    if [ ! -z "$connector" ]; then
        echo "  $connector:"
        curl -s "$CONNECT_URL/connectors/$connector/status"
        echo ""
    fi
done