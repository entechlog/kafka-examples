#!/bin/sh

cd /kafka-connect/config/

echo -e "\n ===> Creating users gender Postgres Sink Connector ⏳⏳⏳"
curl -X POST -H "Content-Type: application/json" --data @connector_postgress_users_gender.config http://kafka-connect:8083/connectors


