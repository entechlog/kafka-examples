import faust
import json
import time
import os
from twilio.rest import Client

#######################################################################
# REQ:  Create Kafka stream processing in python to read message from
#       topic and to make external API call to send out notification
#
# TODO: Add logic to parse AVRO messages
#
# SEE:  https://medium.com/swlh/how-to-deserialize-avro-messages-in-python-faust-400118843447
#       https://www.python.org/dev/peps/pep-0350/
#
# STAT: Inprogress
#######################################################################

# NOTE: To debug set consumer name to "'weather-alert-notify-' + str(time.time())"

app = faust.App(
    'weather-alert-notify',
    broker='kafka://broker:9092',
    value_serializer='raw'
)

json_topic = app.topic('STM_WEATHER_ALERT_APP_9000_NOTIFY', value_type=bytes, key_type=str)

# Faust stream processing
@app.agent(json_topic)
async def processor(records):
    async for record in records:
        des_data = json.loads(record)
        print(des_data)
        
        # Account details from twilio.com
        account_sid = os.environ.get("twilio_account_sid")
        auth_token  = os.environ.get("twilio_auth_token")

        # Phone numbers to send text
        to_phone_number=os.environ.get("to_phone_number")
        twilio_phone_number=os.environ.get("twilio_phone_number")
        
        client = Client(account_sid, auth_token)
        
        message = client.messages.create(
            to=to_phone_number, 
            from_=twilio_phone_number,
            body="It rained in home today 🏄‍")
        
        print(message.sid)