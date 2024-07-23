This is a tutorial for build a native snowflake app

# 1️⃣ Environment Setup
USE DATABASE NATIVE_APP_PACKAGE;

CREATE OR REPLACE SCHEMA NATIVE_APP_SCHEMA;
USE SCHEMA NATIVE_APP_SCHEMA;

CREATE OR REPLACE STAGE NATIVE_APP_STAGE 
    DIRECTORY = ( ENABLE = true ) 
    COMMENT = '';

# 2️⃣ Database and Tables Setup
CREATE OR REPLACE DATABASE NATIVE_APP_DB;
USE DATABASE NATIVE_APP_DB;

CREATE OR REPLACE SCHEMA NATIVE_APP_SCHEMA;
USE SCHEMA NATIVE_APP_SCHEMA;

CREATE OR REPLACE TABLE REGIONAL_SALES (
    PRODUCT_TYPE VARCHAR(255),
    QUANTITY NUMBER(38,0)
);

CREATE OR REPLACE TABLE CUSTOMER_SALES (
    PRODUCT_TYPE VARCHAR(255),
    QUANTITY NUMBER(38,0)
);

# 3️⃣ Configuring Access and Views
use database NATIVE_APP_PACKAGE;
create schema shared_content_schema;

use schema shared_content_schema;
create or replace view REGIONAL_SALES as select * from NATIVE_APP_DB.NATIVE_APP_SCHEMA.REGIONAL_SALES;

grant usage on schema shared_content_schema to share in application package NATIVE_APP_PACKAGE;
grant reference_usage on database NATIVE_APP_DB to share in application package NATIVE_APP_PACKAGE;
grant select on view REGIONAL_SALES to share in application package NATIVE_APP_PACKAGE;

# 4️⃣ App Deployment
USE DATABASE NATIVE_APP_DB;
USE SCHEMA NATIVE_APP_SCHEMA;

CREATE APPLICATION NATIVE_APP_V1 FROM application package NATIVE_APP_PACKAGE using version V1 patch 0;

-- At this point you should see the app NATIVE_APP_V1 listed under Apps
SHOW APPLICATIONS;