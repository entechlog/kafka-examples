#!/usr/bin/env python

# importing the required library 
from confluent_kafka import Producer

### Adding for Avro producer support
from confluent_kafka import avro
from confluent_kafka.avro import AvroProducer
from confluent_kafka.avro.serializer import (KeySerializerError, ValueSerializerError)

from confluent_kafka import SerializingProducer
from confluent_kafka.serialization import StringSerializer
from confluent_kafka.schema_registry import SchemaRegistryClient
from confluent_kafka.schema_registry.avro import AvroSerializer

import confluent_kafka
import requests
import os, sys, time
import argparse
import json
import socket
import datetime

import schemas

def header_footer(process):
    # Display the program start time
    print('-' * 40)
    print((os.path.basename(sys.argv[0])).split('.')[0], process, " at ", time.ctime())
    print('-' * 40)
    
def parse_input():

    print('Number of arguments          :', len(sys.argv))

    # Uncomment only to debug
    # print('Argument List:', str(sys.argv))

    parser = argparse.ArgumentParser(description="""
    Script writes weather data to kafka topic. 
    """)

    parser.add_argument("--bootstrap_servers", help="Bootstrap servers", required=True)
    parser.add_argument("--topic_name", help="Topic name", required=True)
    parser.add_argument("--schema_registry_url", help="Schema registry url", required=True)
    parser.add_argument("--lat", help="latitude", required=True)
    parser.add_argument("--lon", help="longitude", required=True)
    
    args = parser.parse_args()

    bootstrap_servers = args.bootstrap_servers
    topic_name = args.topic_name
    schema_registry_url = args.schema_registry_url
    lat = args.lat
    lon = args.lon

    print("Bootstrap servers            : ", bootstrap_servers)
    print("Topic name                   : ", topic_name)
    print("Schema registry url          : ", schema_registry_url)
    print("Latitude                     : ", lat)
    print("Longitude                    : ", lon)

    return bootstrap_servers, schema_registry_url, topic_name, lat, lon

def call_weather_api(URL, PARAMS):    
    # sending get request and saving the response as response object 
    try:
        json_data = requests.get(url = URL, params = PARAMS, timeout=3)
        json_data.raise_for_status()
        process_data(json_data)
        return json_data
    except requests.exceptions.HTTPError as errh:
        print ("Http Error:",errh)
    except requests.exceptions.ConnectionError as errc:
        print ("Error Connecting:",errc)
    except requests.exceptions.Timeout as errt:
        print ("Timeout Error:",errt)
    except requests.exceptions.RequestException as err:
        print ("OOps: Something Else",err)

class DatetimeEncoder(json.JSONEncoder):
    def default(self, obj):
        try:
            return super(DatetimeEncoder, obj).default(obj)
        except TypeError:
            return str(obj)

def process_data(json_data):
    # extracting data in json format 
    data = json_data.json() 
    
    # extract weather data
    timestamp = data['current']['dt']
    try:
        name = data['name']
    except:
        name = ""
    latitude = data['lat']
    longitude = data['lon']
    weather = data['current']['weather'][0]['description'] 
    temperature = data['current']['temp']
    
    # Print the output 
    print("Timestamp                    : ", str(timestamp))
    print("Latitude                     : ", str(latitude))
    print("Longitude                    : ", str(longitude))
    print("Weather Description          : ", weather)
    print("Temperature                  : ", str(temperature))

def delivery_report(err, msg):
    """ Called once for each message produced to indicate delivery result.
        Triggered by poll() or flush(). """
    if err is not None:
        print("Key Type                     : ", type(key))
        print('Message delivery failed      : {}'.format(err))
    else:
        print('Message delivered to         : {} [{}]'.format(msg.topic(), msg.partition()))

def write_to_kafka(bootstrap_servers, schema_registry_url, topic_name, data):

    print("Kafka Version                : ", confluent_kafka.version(),confluent_kafka.libversion())

    schema_registry_conf = {'url': schema_registry_url}
    schema_registry_client = SchemaRegistryClient(schema_registry_conf)

    value_avro_serializer = AvroSerializer(schemas.weather_source_schema, schema_registry_client)
    string_serializer = StringSerializer('utf-8')

    conf = {'bootstrap.servers': bootstrap_servers,
            'client.id': socket.gethostname(),
            'on_delivery': delivery_report,
            'key.serializer': string_serializer,
            'value.serializer': value_avro_serializer    
            }

    avroProducer = SerializingProducer(conf)
    
    key=datetime.date.today() + '~' + str(data['lat']) + '~' + str(data['lon'])
    message = json.dumps(data, cls=DatetimeEncoder)

    print("Key Type                     : ", type(key))
    print("Value Type                   : ", type(json.loads(message)))
  
    avroProducer.produce(topic=topic_name, key=key, value=json.loads(message))
    avroProducer.flush()

if __name__ == "__main__":
    
    # Print the header
    header_footer("started")

    # Parse the input
    bootstrap_servers, schema_registry_url, topic_name, lat, lon = parse_input()
    
    # api-endpoint 
    URL = "https://api.openweathermap.org/data/2.5/onecall"

    # get environment variables
    OPEN_WEATHER_API_KEY = os.environ.get("OPEN_WEATHER_API_KEY")

    # Prepare inputs for weather api call
    units = "imperial"    
    
    # defining a params dict for the parameters to be sent to the API 
    PARAMS = {'lat':lat,'lon':lon,'exclude':"minutely,hourly",'APPID':OPEN_WEATHER_API_KEY,'units':units}

    # Call weather API
    data = call_weather_api(URL, PARAMS)

    # write data to kafka
    if data is not None:
        write_to_kafka(bootstrap_servers, schema_registry_url, topic_name, data.json())

    # Print the footer
    header_footer("finished")

    sys.exit()
