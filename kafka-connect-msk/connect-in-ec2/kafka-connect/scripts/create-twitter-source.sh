#!/bin/sh

curl -X "POST" "http://kafka-connect:8083/connectors/" \
     -H "Content-Type: application/json" \
     -d '{
  "name": "MY_FAVORITE_CELEBRITIES_SRC_TWITTER",
  "config": {
    "connector.class": "com.github.jcustenborder.kafka.connect.twitter.TwitterSourceConnector",
    "twitter.oauth.consumerKey": "${file:/opt/confluent/secrets/connect-secrets.properties:twitter-api-key}",
    "twitter.oauth.consumerSecret": "${file:/opt/confluent/secrets/connect-secrets.properties:twitter-api-secret-key}",
    "twitter.oauth.accessToken": "${file:/opt/confluent/secrets/connect-secrets.properties:twitter-access-token}",
    "twitter.oauth.accessTokenSecret": "${file:/opt/confluent/secrets/connect-secrets.properties:twitter-access-token-secret}",
    "kafka.status.topic": "twitter.my.favorite.celebrities.src",
    "key.converter": "org.apache.kafka.connect.json.JsonConverter",
    "key.converter.schemas.enable": "false",
    "value.converter": "org.apache.kafka.connect.json.JsonConverter",
    "value.converter.schemas.enable": "false",
    "process.deletes": "false",
    "filter.keywords": "mohanlal,dhoni"
  }
}'