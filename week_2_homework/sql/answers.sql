-- 1. Number of Rows Yellow 2020
SELECT 
    COUNT(*)  
FROM `kestra-sandbox-zoomcamp.zoomcamp.yellow_tripdata` 
WHERE TIMESTAMP_TRUNC(tpep_pickup_datetime, YEAR) = TIMESTAMP("2020-01-01")

-- 2. Number of Rows Green 2020

SELECT 
    COUNT(*)  
FROM `kestra-sandbox-zoomcamp.zoomcamp.green_tripdata` 
WHERE TIMESTAMP_TRUNC(lpep_pickup_datetime, YEAR) = TIMESTAMP("2020-01-01")

-- 3. Number of Rows Yellow March 2021
SELECT 
    COUNT(*)  
FROM `kestra-sandbox-zoomcamp.zoomcamp.yellow_tripdata` 
WHERE TIMESTAMP_TRUNC(tpep_pickup_datetime, DAY) BETWEEN TIMESTAMP("2021-03-01") AND TIMESTAMP("2021-03-31")