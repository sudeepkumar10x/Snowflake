## Snowflake SQL Code

-- Creating a stage for json data

CREATE OR REPLACE STAGE JSON_STAGE
URL = 'azure://msklbusinessdata.blob.core.windows.net/oltp-database-backup'
CREDENTIALS = (AZURE_SAS_TOKEN =
'sp=rl&st=2024-05-29T13:33:05Z&se=2024-06-29T21:33:05Z&spr=https&sv=2022-11-02&sr=c&sig=bWCBgfA38JgZDKCZcOlyfbKJtPgsirqeNUJfOc75Tf8%3D')
FILE_FORMAT = (TYPE = JSON);

- - Creating a temporary table to load JSON file into

CREATE OR REPLACE TEMPORARY TABLE station_info(
src VARIANT
);

- - Copying data from the stage into temp table
COPY INTO station_info
FROM @JSON_STAGE
files = ('station_data.json');

- - Selecting the JSON row
SELECT * FROM station_info;

- - Checking type of data
SELECT TYPEOF(src)
FROM station_info;
  
- - Checking size of the data
SELECT ARRAY_SIZE(src)
FROM station_info;
  
- - Accessing different attributes inside the json object
SELECT $1[0] FROM station_info;

SELECT $1[0]:capacity::int as capacity FROM station_info;

SELECT $1[0]:capacity::int as capacity FROM station_info;

SELECT $1[0]:rental_methods FROM station_info;

SELECT $1[0]:rental_methods[0] FROM station_info;

SELECT $1[0]:rental_uris FROM station_info;

SELECT $1[0]:rental_uris:android FROM station_info;

- - 1st level flattening of data (Method 1)
SELECT
value:station_id::INT as station_id,
value:station_type::STRING as station_type,
value:capacity::INT as capacity,
value:rental_methods::STRING as rental_methods,
value:rental_uris::STRING as rental_uris
FROM station_info,table(FLATTEN (src));


- - (Method 2)
SELECT
value:station_id::INT as station_id,
value:station_type::STRING as station_type,
value:capacity::INT as capacity,
value:rental_methods::STRING as rental_methods,
value:rental_uris::STRING as rental_uris
FROM station_info,LATERAL FLATTEN(input => src);

- - Creating new columns for each rental_method and rental_uris
SELECT
value:station_id::INT as station_id,
value:station_type::STRING as station_type,
value:capacity::INT as capacity,
value:rental_methods[0]::STRING as rental_methods_1,
value:rental_methods[1]::STRING as rental_methods_2,
value:rental_methods[2]::STRING as rental_methods_3,
value:rental_uris::STRING as rental_uris
FROM station_info,LATERAL FLATTEN(input => src);

SELECT
value:station_id::INT as station_id,
value:station_type::STRING as station_type,
value:capacity::INT as capacity,
value:rental_methods[0]::STRING as rental_methods_1,
value:rental_methods[1]::STRING as rental_methods_2,
value:rental_methods[2]::STRING as rental_methods_3,
value:rental_uris:android::STRING as android_uris,
value:rental_uris:ios::STRING as ios_uris
FROM station_info,LATERAL FLATTEN(input => src);

- - 2nd level flattening of data
SELECT
f.value:station_id::INT as station_id,
f.value:station_type::STRING as station_type,
f.value:capacity::INT as capacity,
g.value::STRING as rental_methods,
f.value:rental_uris:android::STRING as android_uris,
f.value:rental_uris:ios::STRING as ios_uris
FROM station_info,LATERAL FLATTEN(input => src) as f, LATERAL FLATTEN (input => f.value:rental_methods) as g;

SELECT
f.value:station_id::INT as station_id,
f.value:station_type::STRING as station_type,
f.value:capacity::INT as capacity,
g.value::STRING as rental_methods,
h.value::STRING as rental_uris
FROM station_info,LATERAL FLATTEN(input => src) as f, LATERAL FLATTEN (input => f.value:rental_methods) as g, LATERAL FLATTEN (input => f.value:rental_uris) as h;
