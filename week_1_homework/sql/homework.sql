/* 
During the period of October 1st 2019 (inclusive) and November 1st 2019 (exclusive), how many trips, **respectively**, happened:
1. Up to 1 mile
2. In between 1 (exclusive) and 3 miles (inclusive),
3. In between 3 (exclusive) and 7 miles (inclusive),
4. In between 7 (exclusive) and 10 miles (inclusive),
5. Over 10 miles 
*/

-- 1. Up to 1 mile
SELECT
	COUNT(1) AS total_trips
FROM green_taxi_trips
WHERE 1=1
AND lpep_pickup_datetime::date >= '2019-01-01'::date
AND lpep_dropoff_datetime::date < '2019-11-01'::date
AND trip_distance <= 1;

-- 2. In between 1 (exclusive) and 3 miles (inclusive)
-- Note: I think the answer for this in the homework rubrick is incorrect, it says 198,924 but the query returns 198,927. All other queries match homeowrk answers.
SELECT
	COUNT(1) AS total_trips
FROM green_taxi_trips
WHERE 1=1
AND lpep_pickup_datetime::date >= '2019-01-01'::date
AND lpep_dropoff_datetime::date < '2019-11-01'::date
AND trip_distance > 1
AND trip_distance <= 3

-- 3. In between 3 (exclusive) and 7 miles (inclusive)
SELECT
	COUNT(1) AS total_trips
FROM green_taxi_trips
WHERE 1=1
AND lpep_pickup_datetime::date >= '2019-01-01'::date
AND lpep_dropoff_datetime::date < '2019-11-01'::date
AND trip_distance > 3
AND trip_distance <= 7

-- In between 7 (exclusive) and 10 miles (inclusive)
SELECT
	COUNT(1) AS total_trips
FROM green_taxi_trips
WHERE 1=1
AND lpep_pickup_datetime::date >= '2019-01-01'::date
AND lpep_dropoff_datetime::date < '2019-11-01'::date
AND trip_distance > 7
AND trip_distance <= 10

-- 5. Over 10 miles 
SELECT
	COUNT(1) AS total_trips
FROM green_taxi_trips
WHERE 1=1
AND lpep_pickup_datetime::date >= '2019-01-01'::date
AND lpep_dropoff_datetime::date < '2019-11-01'::date
AND trip_distance > 10

/*
## Question 4. Longest trip for each day

Which was the pick up day with the longest trip distance?
Use the pick up time for your calculations.

Tip: For every day, we only care about one single trip with the longest distance.
*/


-- There's definitely a better way to do this, but this works.
WITH max_pickup_date AS (
		SELECT
			lpep_pickup_datetime::date AS pickup_date,
			MAX(trip_distance) AS max_daily_trip_distance
		FROM green_taxi_trips
		GROUP BY lpep_pickup_datetime::date
	),

	pickup_dates_ordered AS (
		SELECT
			pickup_date,
			ROW_NUMBER() OVER (ORDER BY max_daily_trip_distance DESC) AS rn
		FROM max_pickup_date
	)

SELECT
	pickup_date
FROM pickup_dates_ordered
WHERE rn=1

/*
## Question 5. Three biggest pickup zones

Which were the top pickup locations with over 13,000 in
`total_amount` (across all trips) for 2019-10-18?

Consider only `lpep_pickup_datetime` when filtering by date.
*/

WITH pickup_zone_amounts AS (
	SELECT
		"Zone" AS pickup_zone,
		SUM(total_amount) AS amount_all_trips
	FROM green_taxi_trips AS gtt
	LEFT JOIN zones AS z
		ON gtt."PULocationID" = z."LocationID"
	WHERE lpep_pickup_datetime::date = '2019-10-18'::date
	GROUP BY 
		1
	)

SELECT
	pickup_zone,
	amount_all_trips
FROM pickup_zone_amounts
WHERE amount_all_trips > 13000

/*## Question 6. Largest tip

For the passengers picked up in October 2019 in the zone
name "East Harlem North" which was the drop off zone that had
the largest tip?

Note: it's `tip` , not `trip`

We need the name of the zone, not the ID.
*/

WITH zones_with_biggest_tips AS (
		SELECT
			dz."Zone" AS dropoff_zone,
			MAX(tip_amount) AS biggest_tip
		FROM green_taxi_trips AS gtt
		LEFT JOIN zones AS pz
			ON gtt."PULocationID" = pz."LocationID"
		LEFT JOIN zones AS dz
			ON gtt."DOLocationID" = dz."LocationID"
		WHERE 1=1
		AND pz."Zone" = 'East Harlem North'
		AND lpep_pickup_datetime::date BETWEEN '2019-10-01'::date AND '2019-10-31'::date
		GROUP BY 1
	),

	ranked_zones_with_tips AS (
		SELECT
			dropoff_zone,
			ROW_NUMBER() OVER (ORDER BY biggest_tip DESC) AS rn
		FROM zones_with_biggest_tips
	)

SELECT
	dropoff_zone
FROM ranked_zones_with_tips
WHERE rn = 1