#!/bin/sh

curl -i -X PUT -H  "Content-Type:application/json" \
    http://kafka-connect:8083/connectors/WEATHER_ALERT_TWILIO_HTTP_SINK/config \
    -d '{
        "connector.class":"io.confluent.connect.http.HttpSinkConnector",
        "tasks.max":1,
        "topics":"STM_WEATHER_ALERT_APP_9000_NOTIFY",
        "key.converter": "org.apache.kafka.connect.storage.StringConverter",
        "value.converter": "org.apache.kafka.connect.storage.StringConverter",
        "confluent.topic.bootstrap.servers": "broker:9092",
        "confluent.topic.replication.factor": "1",
        "reporter.bootstrap.servers": "broker:9092",
        "reporter.result.topic.name": "${connector}-success-responses",
        "reporter.result.topic.replication.factor": "1",
        "reporter.error.topic.name":"${connector}-error-responses",
        "reporter.error.topic.replication.factor":"1",
        "request.body.format":"string",
        "http.api.url":"https://api.twilio.com/2010-04-01/Accounts/${file:/opt/confluent/secrets/connect-secrets.properties:twilio-account-sid}/Messages.json",
        "request.method":"POST",
        "behavior.on.error":"log",
        "headers":"Authorization: Basic ${file:/opt/confluent/secrets/connect-secrets.properties:twilio-auth-token}",
        "headers":"Content-Type: application/x-www-form-urlencoded"
    }'
