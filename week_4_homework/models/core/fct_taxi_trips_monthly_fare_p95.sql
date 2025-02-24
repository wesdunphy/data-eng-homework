{{ config(materialized='table') }}

with trips_data as (
    select * from {{ ref('fact_trips') }}
),

helpers AS (
    SELECT
        *,
        {{ dbt.date_trunc('month', 'pickup_datetime')}} AS month,
        {{ dbt.date_trunc('year', 'pickup_datetime')}} AS year
    FROM trips_data
)

    SELECT
        service_type,
        month,
        year,
        PERCENTILE_CONT(fare_amount, 0.9) OVER (PARTITION BY year, month, service_type) AS p90,
        PERCENTILE_CONT(fare_amount, 0.95) OVER (PARTITION BY year, month, service_type) AS p95,
        PERCENTILE_CONT(fare_amount, 0.97) OVER (PARTITION BY year, month, service_type) AS p97
    FROM helpers
    WHERE fare_amount > 0
    AND trip_distance > 0
    AND payment_type_description IN ('Cash', 'Credit Card')