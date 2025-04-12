-- models/core/core_stats.sql
-- Combine ride records with station catalog data for complete geographic insights.

select
  e.ride_id,
  e.source_file,
  e.ingestion_ts,
  e.bike_id,
  e.user_age,
  e.user_gender,
  e.origin_datetime,
  e.destination_datetime,
  e.ride_duration_minutes,

  e.origin_station_id,
  s_from.name as origin_station_name,
  s_from.lat as origin_lat,
  s_from.lon as origin_lon,

  r.destination_station_id,
  s_to.name as destination_station_name,
  s_to.lat as destination_lat,
  s_to.lon as destination_lon,

  case
    when e.origin_datetime is null or e.destination_datetime is null then 'missing_datetime'
    when e.ride_duration_minutes is null or e.ride_duration_minutes <= 0 then 'invalid_duration'
    when e.ride_duration_minutes > 240 then 'too_long'
    else 'valid'
  end as ride_quality_flag

from {{ ref('stg_rides_enriched') }} e
left join {{ ref('stg_stations') }} s_from
  on e.origin_station_id = s_from.station_id
left join {{ ref('stg_stations') }} s_to
  on r.destination_station_id = s_to.station_id