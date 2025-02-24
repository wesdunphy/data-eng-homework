{{ config(materialized='table') }}

with trips_data as (
    select * from {{ ref('fact_fhv_trips') }}
),

trip_durations AS (
    select
    *,
    TIMESTAMP_DIFF(CAST(dropoff_datetime as timestamp), cast(pickup_datetime as timestamp), SECOND) AS trip_duration
FROM trips_data
)

select  
    *,
    PERCENTILE_CONT(trip_duration, 0.9) OVER (PARTITION BY year, month, pickup_zone, dropoff_zone) AS p90
FROM trip_durations