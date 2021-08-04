from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from datetime import datetime, timedelta
from airflow.operators.docker_operator import DockerOperator

# TODO: Add logic to set DockerOperator environments than hard coding

default_args = {
        'owner'                 : 'airflow',
        'description'           : 'Runs the python module to source weather data from openweather',
        'depend_on_past'        : False,
        'start_date'            : datetime(2020, 12, 26),
        'email_on_failure'      : False,
        'email_on_retry'        : False,
        'retries'               : 1,
        'retry_delay'           : timedelta(minutes=5),
        'schedule_interval'     : '*/15 * * * *' # Every 15 minutes
}

with DAG('weather-alert-source-data', default_args=default_args, schedule_interval='*/15 * * * *', catchup=False) as dag:
        
        t1 = BashOperator(
                task_id='print_start_time',
                bash_command='echo `date "+%Y-%m-%d%H:%M:%S"` "- Airflow Task Started"'
        )
        
        t2 = DockerOperator(
                task_id='docker_command',
                image='entechlog/weather-alert-app:latest',
                api_version='auto',
                auto_remove=True,
                docker_url="unix://var/run/docker.sock",
                network_mode="weatheralertapp_default",
                environment={
                        'bootstrap_servers': "broker:9092",
                        'schema_registry_url': "http://schema-registry:8081",
                        'topic_name': "weather.alert.app.source",
                        'lat': "8.270272",
                        'lon': "77.177274",
                        'OPEN_WEATHER_API_KEY': ""
                        }
        )
        
        t3 = BashOperator(
                task_id='print_end_time',
                bash_command='echo `date "+%Y-%m-%d%H:%M:%S"` "- Airflow Task Finished"'
        )

        t1 >> t2 >> t3