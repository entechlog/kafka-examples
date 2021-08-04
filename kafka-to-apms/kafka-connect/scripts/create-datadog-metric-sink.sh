#!/bin/sh

curl -i -X PUT -H  "Content-Type:application/json" \
    http://kafka-connect:8083/connectors/METRIC_DATADOG_SINK/config \
    -d '{
        "connector.class":"io.confluent.connect.datadog.metrics.DatadogMetricsSinkConnector",
        "tasks.max":1,
        "confluent.topic.bootstrap.servers": "broker:9092",
        "topics":"backend-server-capacity",
        "key.converter": "org.apache.kafka.connect.storage.StringConverter",
        "key.converter.schemas.enable":false,
        "value.converter":"io.confluent.connect.avro.AvroConverter",
        "value.converter.schemas.enable": true,
        "value.converter.schema.registry.url": "http://schema-registry:8081",
        "datadog.api.key":"${file:/opt/confluent/secrets/connect-secrets.properties:datadog-api-key}",
        "datadog.domain":"COM",
        "behavior.on.error": "fail",
        "reporter.bootstrap.servers": "broker:9092",
        "reporter.error.topic.name": "datadog-sample-events-error",
        "reporter.error.topic.replication.factor": 1,
        "reporter.result.topic.name": "datadog-sample-events-success",
        "reporter.result.topic.replication.factor": 1
    }'