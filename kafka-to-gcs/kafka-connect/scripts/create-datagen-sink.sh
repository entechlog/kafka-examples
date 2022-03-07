#!/bin/sh

cd /kafka-connect/config/sink/

curl -X POST -H "Content-Type: application/json" --data @connector_sink_users.config http://kafka-connect:8083/connectors