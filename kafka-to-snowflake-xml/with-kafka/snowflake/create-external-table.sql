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
	OR REPLACE EXTERNAL TABLE DEMO_DB.FAKER.DATAGEN_XML_TBL
	WITH LOCATION = @DEMO_DB.FAKER.DATAGEN_S3_STG FILE_FORMAT = DEMO_DB.FAKER.DATAGEN_FILE_FORMAT;

-- Validate data in RAW XML
SELECT * FROM DEMO_DB.FAKER.DATAGEN_XML_TBL;

-- Identify all column names from xml tag
SELECT GET(Elements.value, '@')::string nodeType,
	count(*)
FROM DEMO_DB.FAKER.DATAGEN_XML_TBL,
	LATERAL FLATTEN(GET(DEMO_DB.FAKER.DATAGEN_XML_TBL.VALUE, '$')) Elements
GROUP BY nodeType;

-- Parse individual xml tags
  SELECT
     XMLGET( value, 'username' ):"$"::string AS username,
     XMLGET( value, 'name' ):"$"::string AS name,
     XMLGET( value, 'sex' ):"$"::string AS sex,
     XMLGET( value, 'address' ):"$"::string AS address,
     XMLGET( value, 'mail' ):"$"::string AS mail,
     XMLGET( value, 'birthdate' ):"$"::string AS birthdate
  FROM DEMO_DB.FAKER.DATAGEN_XML_TBL;

-- Parse Complex XML
select Elements.value 
from DEMO_DB.FAKER.DATAGEN_XML_TBL,
lateral flatten(DEMO_DB.FAKER.DATAGEN_XML_TBL.VALUE:"$") as Elements;
