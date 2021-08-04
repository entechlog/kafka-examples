#!/bin/sh

curl -i -X PUT -H  "Content-Type:application/json" \
    http://kafka-connect:8083/connectors/METRIC_NEWRELIC_SINK/config \
    -d '{
        "connector.class":"com.newrelic.telemetry.metrics.TelemetryMetricsSinkConnector",
        "tasks.max":1,
        "confluent.topic.bootstrap.servers": "broker:9092",
        "topics":"newrelic-sample-events-no-schema",
        "key.converter": "org.apache.kafka.connect.storage.StringConverter",
        "key.converter.schemas.enable":false,
        "value.converter":"com.newrelic.telemetry.metrics.MetricsConverter",
        "value.converter.schemas.enable": false,
        "api.key":"${file:/opt/confluent/secrets/connect-secrets.properties:newrelic-api-key}",
        "behavior.on.error": "fail",
        "reporter.bootstrap.servers": "broker:9092",
        "reporter.error.topic.name": "newrelic-sample-events-error",
        "reporter.error.topic.replication.factor": 1,
        "reporter.result.topic.name": "newrelic-sample-events-success",
        "reporter.result.topic.replication.factor": 1
    }'