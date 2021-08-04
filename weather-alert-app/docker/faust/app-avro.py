import faust
import fastavro
import json
import io
from io import StringIO
from fastavro import schemaless_reader, schemaless_writer, parse_schema
from io import BytesIO
import time

# 20200101 - Testing with confluent_kafka
from confluent_kafka import Consumer, KafkaError
from avro.io import DatumReader, BinaryDecoder
import avro.schema
from confluent_kafka import Consumer

app = faust.App(
    'weather-alert-consumer-' + str(time.time()),
    broker='kafka://broker:9092',
    value_serializer='raw'
)

avro_topic = app.topic('TBL_WEATHER_ALERT_APP_0020_RAIN_IS_HERE', value_type=bytes, key_type=str)

# Schema from Confluent Schema Registry
# export TOPIC=TBL_WEATHER_ALERT_APP_0020_RAIN_IS_HERE
# export SCHEMA_VERSION=1
# curl http://entechlog-vm-01:8081/subjects/$TOPIC-value/versions/$SCHEMA_VERSION | jq -r '.schema|fromjson' > $TOPIC-$SCHEMA_VERSION-value.avsc

avro_schema_str = {
  "fields": [
    {
      "name": "CURRENT_DT_TIME",
      "type": [
        "null",
        "int"
      ]
    },
    {
      "name": "CURRENT_TEMP",
      "type": [
        "null",
        "double"
      ]
    },
    {
      "name": "CURRENT_WEATHER_DESC",
      "type": [
        "null",
        "string"
      ]
    }
  ],
  "name": "KsqlDataSourceSchema",
  "namespace": "io.confluent.ksql.avro_schemas",
  "type": "record"
}

# 20200101 - Testing with confluent_kafka
schema = avro.schema.Parse(open("/usr/app/TBL_WEATHER_ALERT_APP_0020_RAIN_IS_HERE-value.avsc").read())
reader = DatumReader(schema)

def decode(msg_value):
    message_bytes = io.BytesIO(msg_value)
    decoder = BinaryDecoder(message_bytes)
    event_dict = reader.read(decoder)
    return event_dict

def fast_avro_decode(schema, encoded_message):
    stringio = io.BytesIO(encoded_message)
    return fastavro.schemaless_reader(stringio, schema)
    
@app.agent(avro_topic)
async def processor(records):
    async for record in records:
        schema = fastavro.parse_schema(avro_schema_str)
        if record is not None:
            des_data = fast_avro_decode(schema, record)
            print(record)
            print(des_data)
            event_dict = decode(record)
            print(event_dict)

conf = {'bootstrap.servers': "broker:9092",
        'group.id': 'weather-alert-confluent-consumer-' + str(time.time()),
        'auto.offset.reset': 'earliest'}

consumer = Consumer(conf)
topics=["TBL_WEATHER_ALERT_APP_0020_RAIN_IS_HERE"]
consumer.subscribe(topics)

running = True
while running:
    msg = consumer.poll()
    if not msg.error():
        msg_value = msg.value()
        if msg_value is not None:
            event_dict = decode(msg_value)
            print(event_dict)
    elif msg.error().code() != KafkaError._PARTITION_EOF:
        print(msg.error())
        running = False