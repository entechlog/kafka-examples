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
    "key.converter": "io.confluent.connect.avro.AvroConverter",
    "key.converter.schemas.enable": "true",
    "key.converter.schema.registry.url": "http://schema-registry:8081",
    "value.converter": "io.confluent.connect.avro.AvroConverter",
    "value.converter.schemas.enable": "true",
    "value.converter.schema.registry.url": "http://schema-registry:8081",
    "process.deletes": "false",
    "filter.keywords": "mohanlal,dhoni"
  }
}'