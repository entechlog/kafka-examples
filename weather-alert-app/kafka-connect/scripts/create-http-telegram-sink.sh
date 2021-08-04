#!/bin/sh

curl -i -X PUT -H  "Content-Type:application/json" \
    http://kafka-connect:8083/connectors/WEATHER_ALERT_TELEGRAM_HTTP_SINK/config \
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
        "http.api.url": "https://api.telegram.org/bot${file:/opt/confluent/secrets/connect-secrets.properties:telegram-bot-api-key}/sendMessage?chat_id=${file:/opt/confluent/secrets/connect-secrets.properties:telegram-bot-destination-chat-id}&text=It%20rained%20in%20home%20today"
    }'