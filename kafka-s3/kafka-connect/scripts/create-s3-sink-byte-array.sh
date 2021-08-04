#!/bin/sh

curl -i -X PUT -H  "Content-Type:application/json" \
    http://kafka-connect:8083/connectors/MOCKAROO_BA_S3_SINK/config \
    -d '{
        "connector.class":"io.confluent.connect.s3.S3SinkConnector",
        "tasks.max":1,
        "topics":"sample-event-byte-array-no-schema",
        "key.converter": "org.apache.kafka.connect.converters.ByteArrayConverter",
        "key.converter.schemas.enable":false,
        "value.converter":"org.apache.kafka.connect.converters.ByteArrayConverter",
        "value.converter.schemas.enable": false,
        "s3.bucket.name":"${file:/opt/confluent/secrets/connect-secrets.properties:s3-BucketName}",
        "s3.part.size":"5242880",
        "s3.compression.type":"none",
        "flush.size":"1000",
        "rotate.interval.ms":"180000",
        "retry.backoff.ms":"1000",
        "topics.dir":"byte-array-demo-time-partitioner",
        "file.delim":"-",
        "aws.access.key.id": "${file:/opt/confluent/secrets/connect-secrets.properties:s3-AccessKeyID}",
        "aws.secret.access.key": "${file:/opt/confluent/secrets/connect-secrets.properties:s3-SecretAccessKey}",
        "format.class": "io.confluent.connect.s3.format.bytearray.ByteArrayFormat",
        "storage.class": "io.confluent.connect.s3.storage.S3Storage",
        "schema.compatibility": "NONE",
        "schemas.enable":false,
        "partitioner.class": "io.confluent.connect.storage.partitioner.HourlyPartitioner",
        "locale": "en-US",
        "timezone": "UTC",
        "timestamp.extractor": "Record"
    }'