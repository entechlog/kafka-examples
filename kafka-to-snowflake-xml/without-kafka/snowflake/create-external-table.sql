-- Create the demo database
USE ROLE SYSADMIN;
CREATE OR REPLACE DATABASE DEMO_DB;

-- Create Schema
CREATE OR REPLACE SCHEMA DEMO_DB.FAKER;

-- Create storage integration, Update STORAGE_AWS_ROLE_ARN and STORAGE_ALLOWED_LOCATIONS
USE ROLE ACCOUNTADMIN;
CREATE OR REPLACE STORAGE INTEGRATION DATAGEN_XML_INT
TYPE = EXTERNAL_STAGE
STORAGE_PROVIDER = S3
ENABLED = TRUE
STORAGE_AWS_ROLE_ARN = 'iam-role-for-s3'
STORAGE_ALLOWED_LOCATIONS = ('s3://entechlog-demo/snowflake-xml-demo/');

-- Verify the Integration
SHOW INTEGRATIONS;

-- Describe Integration and retrieve the AWS IAM User (STORAGE_AWS_IAM_USER_ARN and STORAGE_AWS_EXTERNAL_ID) for Snowflake Account
DESC INTEGRATION DATAGEN_XML_INT;

-- Grant the IAM user permissions to access S3 Bucket. See blog for details on this

-- Create file format for incoming files
CREATE OR REPLACE FILE FORMAT DEMO_DB.FAKER.DATAGEN_FILE_FORMAT
TYPE = XML COMPRESSION = AUTO;

-- Verify the File Format
SHOW FILE FORMATS;

-- Create state for incoming files. Update `URL` with s3 bucket details
CREATE OR REPLACE STAGE DEMO_DB.FAKER.DATAGEN_S3_STG
STORAGE_INTEGRATION = DATAGEN_XML_INT
URL = 's3://entechlog-demo/snowflake-xml-demo/'
FILE_FORMAT = DATAGEN_FILE_FORMAT;

-- Verify Stage
SHOW STAGES;
LIST @DEMO_DB.FAKER.DATAGEN_S3_STG;

-- Create external table for RAW XML
CREATE
	OR REPLACE EXTERNAL TABLE DEMO_DB.FAKER.DATAGEN_XML_RAW
	WITH LOCATION = @DEMO_DB.FAKER.DATAGEN_S3_STG FILE_FORMAT = DEMO_DB.FAKER.DATAGEN_FILE_FORMAT;

-- Validate data in RAW XML
SELECT * FROM DEMO_DB.FAKER.DATAGEN_XML_RAW;

SELECT current_timestamp::TIMESTAMP log_ts
	,left(metadata$filename, 77) path_name
	,regexp_replace(metadata$filename, '.*\/(.*)', '\\1') file_name
	,metadata$file_row_number file_row_number
	,XMLGET($1, 'username'):"$"::string AS username
	,XMLGET($1, 'name'):"$"::string AS name
	,XMLGET($1, 'sex'):"$"::string AS sex
	,XMLGET($1, 'address'):"$"::string AS address
	,XMLGET($1, 'mail'):"$"::string AS mail
	,XMLGET($1, 'birthdate'):"$"::string AS birthdate
FROM @DEMO_DB.FAKER.DATAGEN_S3_STG;

-- Identify all column names from xml tag
SELECT GET(Elements.value, '@')::string nodeType,
	count(*)
FROM DEMO_DB.FAKER.DATAGEN_XML_RAW,
	LATERAL FLATTEN(GET(DEMO_DB.FAKER.DATAGEN_XML_RAW.VALUE, '$')) Elements
GROUP BY nodeType;

-- Parse individual xml tags
  SELECT
     XMLGET( value, 'username' ):"$"::string AS username,
     XMLGET( value, 'name' ):"$"::string AS name,
     XMLGET( value, 'sex' ):"$"::string AS sex,
     XMLGET( value, 'address' ):"$"::string AS address,
     XMLGET( value, 'mail' ):"$"::string AS mail,
     XMLGET( value, 'birthdate' ):"$"::string AS birthdate
  FROM DEMO_DB.FAKER.DATAGEN_XML_RAW;

-- Parse Complex XML
select Elements.value 
from DEMO_DB.FAKER.DATAGEN_XML_RAW,
lateral flatten(DEMO_DB.FAKER.DATAGEN_XML_RAW.VALUE:"$") as Elements;

-- Create parsed external table
CREATE OR REPLACE EXTERNAL TABLE DEMO_DB.FAKER.DATAGEN_XML_PARSED(
     log_ts timestamp as (current_timestamp::TIMESTAMP)
	,path_name varchar as (left(metadata$filename, 77))
	,file_name varchar as (regexp_replace(metadata$filename, '.*\/(.*)', '\\1'))
	,username varchar as (XMLGET($1, 'username'):"$"::string)
	,name varchar as (XMLGET($1, 'name'):"$"::string)
	,sex varchar as (XMLGET($1, 'sex'):"$"::string)
	,address varchar as (XMLGET($1, 'address'):"$"::string)
	,mail varchar as (XMLGET($1, 'mail'):"$"::string)
	,birthdate varchar as (XMLGET($1, 'birthdate'):"$"::string))
WITH LOCATION = @DEMO_DB.FAKER.DATAGEN_S3_STG 
FILE_FORMAT = DEMO_DB.FAKER.DATAGEN_FILE_FORMAT
AUTO_REFRESH = TRUE;

-- Validate data in parsed table
SELECT * FROM DEMO_DB.FAKER.DATAGEN_XML_PARSED;