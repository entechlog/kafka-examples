# Overview

Demo repo to show how to bring up a standalone kafka connector for POC's.

## Notes

- The reason for using standalone connector is just for POC'ing without writing back offsets to Kafka broker. Standalone connectors should be never used beyond POC
- This demo also has example on how to use SASL_SSL
- CamelCased connect variable like `defaultDataset` should be mentioned as `CONNECTOR_CAMELCASE_DEFAULT_DATASET`. This is a customization done on standalone template to add support from BQ CamelCase variables
- If you get `'bash\r'` error, please run `sudo find . -type f -exec dos2unix {} \;` to do windows to dos conversion

## How to start standalone connector ?

- Create copy of `.env.template` as `.env` and update the parameters specific for your environment
- Create copy of `connect.jaas.template` as `connect.jaas` and update the parameters specific for your environment
- This demo repo is configured to use Big Query connector, but can be also updated to use any other connector
- Bring up the container by running `docker-compose up -d --build`
- If you get `'bash\r'` error, please run `sudo find . -type f -exec dos2unix {} \;` to do windows to dos conversion

## How to stop the standalone connector ?

- You can bring down the services by running `docker-compose down`

## Reference

- https://docs.confluent.io/platform/current/tutorials/build-your-own-demos.html#standalone-mode
- https://github.com/confluentinc/cp-all-in-one/blob/6.2.1-post/cp-all-in-one-cloud/docker-compose.connect.standalone.yml
