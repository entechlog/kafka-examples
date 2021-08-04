FROM python:3.7

COPY . /usr/src/
WORKDIR /usr/src/

# un-comment only if the confluent-kafka install fails
#RUN git clone https://github.com/edenhill/librdkafka.git
#RUN pwd
#RUN cd /usr/src/librdkafka/ && ./configure --install-deps && make && make install && ldconfig

COPY requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt

RUN apt-get update && apt-get install -y \
    iputils-ping \
    iproute2 \
    curl \
	dos2unix \
	netcat \
	net-tools \
 && rm -rf /var/lib/apt/lists/*

COPY . .

ARG bootstrap_servers
ARG topic_name 
ARG no_of_records
ARG loop_delay
ARG S3_BUCKET_NAME
ARG S3_ACCESS_KEY
ARG S3_SECRET_KEY
ARG write_to_s3
ARG write_to_kafka

ENV bootstrap_servers $bootstrap_servers
ENV topic_name $topic_name
ENV no_of_records $no_of_records
ENV loop_delay $loop_delay

ENV S3_BUCKET_NAME $S3_BUCKET_NAME
ENV S3_ACCESS_KEY $S3_ACCESS_KEY
ENV S3_SECRET_KEY $S3_SECRET_KEY

ENV write_to_s3 $write_to_s3
ENV write_to_kafka $write_to_kafka

CMD ["sh", "-c", "python /usr/src/app/faker-kafka-profile-datagen.py --bootstrap_servers $bootstrap_servers --topic_name $topic_name --no_of_records $no_of_records --loop_delay $loop_delay"]
