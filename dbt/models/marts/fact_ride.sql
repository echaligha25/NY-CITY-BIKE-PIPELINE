-- models/marts/fact_ride.sql
-- Daily summary of Citibike rides with basic metrics and long ride count

select
  date(origin_datetime) as ride_date,
  count(*) as total_rides,
  avg(ride_duration_minutes) as avg_duration_minutes,
  count(distinct bike_id) as unique_bikes_used,
  count(distinct origin_station_id) as unique_origin_stations,
  count(distinct destination_station_id) as unique_destination_stations,
  sum(case when ride_duration_minutes > 45 then 1 else 0 end) as rides_over_45_min
from {{ ref('ride_station') }}
where
  origin_datetime is not null
  and ride_quality_flag = 'valid'
group by 1
order by 1