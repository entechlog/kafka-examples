#!/bin/bash

for i in {1..140}; do
        
        fixedVar=500
        i=$(($fixedVar + $i))

        echo 'http://localhost:8081/subjects/kafka-value-'$i'/versions'

        curl -X POST -H "Content-Type: application/vnd.schemaregistry.v1+json" \
         --data '{ "schema": "{ \"type\": \"record\", \"name\": \"Person\", \"namespace\": \"com.example.kafka\", \"fields\": [ { \"name\": \"firstName'"$i"'\", \"type\": \"string\" } ]}" }' \
        'http://localhost:8081/subjects/kafka-value-'$i'/versions'

done