-- models/staging/stg_rides_enriched.sql
-- Processed version of raw ride data with typed fields, local datetime, and ride duration

SELECT
  -- Technical identifiers
  ride_id,
  source_file,
  ingestion_ts,

  -- Bike information
  CAST(bike AS INT64) AS bike_id,

  -- Origin station
  TRIM(SPLIT(LTRIM(origin_station, '0'), '-')[SAFE_OFFSET(0)]) AS origin_station_id,
  origin_date AS origin_date,
  origin_time AS origin_time,
  SAFE.PARSE_DATETIME('%d/%m/%Y %H:%M:%S', CONCAT(origin_date, ' ', origin_time)) AS origin_datetime,

  -- Destination station
  TRIM(SPLIT(LTRIM(destination_station, '0'), '-')[SAFE_OFFSET(0)]) AS destination_station_id,
  destination_date AS destination_date,
  destination_time AS destination_time,
  SAFE.PARSE_DATETIME('%d/%m/%Y %H:%M:%S', CONCAT(destination_date, ' ', destination_time)) AS destination_datetime,

  -- User info
  CAST(user_age AS INT64) AS user_age,
  user_gender AS user_gender,

  -- Ride duration in minutes
  DATETIME_DIFF(
    SAFE.PARSE_DATETIME('%d/%m/%Y %H:%M:%S', CONCAT(destination_date, ' ', destination_time)),
    SAFE.PARSE_DATETIME('%d/%m/%Y %H:%M:%S', CONCAT(origin_date, ' ', origin_time)),
    MINUTE
  ) AS ride_duration_minutes

FROM {{ source('staging', 'citibike_tripdata') }}
WHERE
  origin_date IS NOT NULL
  AND origin_time IS NOT NULL
  AND destination_date IS NOT NULL
  AND destination_time IS NOT NULL;
