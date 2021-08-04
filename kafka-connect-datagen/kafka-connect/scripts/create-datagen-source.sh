#!/bin/sh

cd /kafka-connect/config/

curl -X POST -H "Content-Type: application/json" --data @connector_pageviews.config http://kafka-connect:8083/connectors

curl -X POST -H "Content-Type: application/json" --data @connector_product.config http://kafka-connect:8083/connectors

curl -X POST -H "Content-Type: application/json" --data @connector_stock_trades.config http://kafka-connect:8083/connectors

curl -X POST -H "Content-Type: application/json" --data @connector_users.config http://kafka-connect:8083/connectors