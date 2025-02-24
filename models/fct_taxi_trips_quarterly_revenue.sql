{{ config(materialized='table') }}

with trips_data as (
    select * from {{ ref('fact_trips') }}
),

revenue_by_quarter AS (
    SELECT 
         EXTRACT(QUARTER FROM pickup_datetime)AS revenue_quarter, 
         EXTRACT(YEAR FROM pickup_datetime)AS revenue_year,
        service_type, 

        -- Revenue calculations
        SUM(total_amount) AS revenue_quarterly_total_amount,

        -- Additional calculations
        COUNT(tripid) AS total_quarterly_trips,
        AVG(passenger_count) AS avg_quarterly_passenger_count,
        AVG(trip_distance) AS avg_quarterly_trip_distance
    FROM trips_data
    WHERE EXTRACT(YEAR FROM pickup_datetime) IN (2019, 2020)  -- Compare only 2019 vs. 2020
    GROUP BY 1, 2, 3
),

yoy_revenue AS (
    SELECT 
        *,
        LAG(revenue_quarterly_total_amount) OVER (
            PARTITION BY service_type, revenue_quarter  -- Compare same quarter of previous year
            ORDER BY revenue_year
        ) AS prev_year_revenue,

        -- YoY revenue growth percentage
        SAFE_DIVIDE(
            revenue_quarterly_total_amount - LAG(revenue_quarterly_total_amount) OVER (
                PARTITION BY service_type, revenue_quarter  
                ORDER BY revenue_year
            ),
            LAG(revenue_quarterly_total_amount) OVER (
                PARTITION BY service_type, revenue_quarter  
                ORDER BY revenue_year
            )
        ) AS yoy_growth_percentage
    FROM revenue_by_quarter
)

SELECT * FROM yoy_revenue
ORDER BY revenue_year, revenue_quarter, service_type
