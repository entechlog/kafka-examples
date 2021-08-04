-- Create the demo database
USE ROLE SYSADMIN;
CREATE OR REPLACE DATABASE DEMO_DB;

-- Create Schema
CREATE OR REPLACE SCHEMA DEMO_DB.SNOWPIPE;

-- Create storage integration
USE ROLE ACCOUNTADMIN;
CREATE OR REPLACE STORAGE INTEGRATION MOCKAROO_S3_INT
TYPE = EXTERNAL_STAGE
STORAGE_PROVIDER = S3
ENABLED = TRUE
STORAGE_AWS_ROLE_ARN = 'iam-role'
STORAGE_ALLOWED_LOCATIONS = ('s3://entechlog-demo/kafka-snowpipe-demo/');

-- Verify the Integration
SHOW INTEGRATIONS;

-- DO NOT RUN
DROP INTEGRATION MOCKAROO_S3_INT;

-- Describe Integration and retrieve the AWS IAM User (STORAGE_AWS_IAM_USER_ARN and STORAGE_AWS_EXTERNAL_ID) for Snowflake Account
DESC INTEGRATION MOCKAROO_S3_INT;

-- Grant the IAM user permissions to access S3 Bucket. See blog for details on this

-- Create file format for incoming files
CREATE OR REPLACE FILE FORMAT DEMO_DB.SNOWPIPE.MOCKAROO_FILE_FORMAT
TYPE = JSON COMPRESSION = AUTO TRIM_SPACE = TRUE NULL_IF = ('NULL', 'NULL');

-- Verify the File Format
SHOW FILE FORMATS;

-- Create state for incoming files. Update `URL` with s3 bucket details
CREATE OR REPLACE STAGE DEMO_DB.SNOWPIPE.MOCKAROO_S3_STG
STORAGE_INTEGRATION = MOCKAROO_S3_INT
URL = 's3://entechlog-demo/kafka-snowpipe-demo/'
FILE_FORMAT = MOCKAROO_FILE_FORMAT;

-- Verify Stage
SHOW STAGES;
LIST @DEMO_DB.SNOWPIPE.MOCKAROO_S3_STG

-- Create target table for JSON data
CREATE OR REPLACE TABLE DEMO_DB.SNOWPIPE.MOCKAROO_RAW_TBL (
         "event" VARIANT
);

-- Describe table
DESC TABLE DEMO_DB.SNOWPIPE.MOCKAROO_RAW_TBL;

-- Create snowpipe to ingest data from `STAGE` to `TABLE`
CREATE
	OR REPLACE PIPE DEMO_DB.SNOWPIPE.MOCKAROO_SNOWPIPE AUTO_INGEST = TRUE AS COPY
INTO DEMO_DB.SNOWPIPE.MOCKAROO_RAW_TBL
FROM @DEMO_DB.SNOWPIPE.MOCKAROO_S3_STG;

-- Describe snowpipe and copy the ARN for notification_channel	
SHOW PIPES LIKE '%MOCKAROO_SNOWPIPE%';

-- Validate the snowpipe status
SELECT SYSTEM$PIPE_STATUS('DEMO_DB.SNOWPIPE.MOCKAROO_SNOWPIPE');

-- Validate data in snowflake
SELECT * FROM DEMO_DB.SNOWPIPE.MOCKAROO_RAW_TBL;

-- Pause pipe
ALTER PIPE DEMO_DB.SNOWPIPE.MOCKAROO_SNOWPIPE
SET PIPE_EXECUTION_PAUSED = TRUE;

-- Truncate table before reloading
TRUNCATE TABLE DEMO_DB.SNOWPIPE.MOCKAROO_RAW_TBL;

-- Set pipe for refresh
ALTER PIPE DEMO_DB.SNOWPIPE.MOCKAROO_SNOWPIPE REFRESH;

-- Create Parsed table
CREATE OR REPLACE TABLE DEMO_DB.SNOWPIPE.MOCKAROO_PARSED_TBL (
         "log_ts" TIMESTAMP,
         "path_name" STRING,
         "file_name" STRING,
		 "file_row_number" STRING,
		 "id" STRING,
		 "first_name" STRING,
		 "last_name" STRING,
         "gender" STRING,
		 "company_name" STRING,
		 "job_title" STRING,
		 "slogan" STRING,
		 "email" STRING
);

-- Create snowpipe for Parsed table
CREATE PIPE DEMO_DB.SNOWPIPE.MOCKAROO_PARSED_SNOWPIPE AUTO_INGEST = TRUE AS COPY
INTO DEMO_DB.SNOWPIPE.MOCKAROO_PARSED_TBL
FROM (
	SELECT current_timestamp::TIMESTAMP log_ts
		,left(metadata$filename, 77) path_name
		,regexp_replace(metadata$filename, '.*\/(.*)', '\\1') file_name
		,metadata$file_row_number file_row_number
		,$1:id
		,$1:first_name
		,$1:last_name
		,$1:gender
		,$1:company_name
		,$1:job_title
		,$1:slogan
		,$1:email
	FROM @DEMO_DB.SNOWPIPE.MOCKAROO_S3_STG
	);