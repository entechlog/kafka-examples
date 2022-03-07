#!/bin/sh

cd /kafka-connect/config/source/

curl -X POST -H "Content-Type: application/json" --data @connector_src_pageviews.config http://kafka-connect:8083/connectors

curl -X POST -H "Content-Type: application/json" --data @connector_src_product.config http://kafka-connect:8083/connectors

curl -X POST -H "Content-Type: application/json" --data @connector_src_stock_trades.config http://kafka-connect:8083/connectors

curl -X POST -H "Content-Type: application/json" --data @connector_src_users.config http://kafka-connect:8083/connectors