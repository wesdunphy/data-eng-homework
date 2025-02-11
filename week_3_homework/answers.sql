-- Creating external table referring to gcs path
CREATE OR REPLACE EXTERNAL TABLE `load_ny_taxi_data_dataset.external_yellow_tripdata`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://data-zoomcamp-wesdunphy-manual-bucket/yellow/yellow_tripdata_2024-*.parquet']
);

-- Check yello trip data
SELECT * FROM `load_ny_taxi_data_dataset.external_yellow_tripdata` limit 10;

-- Create a non partitioned table from external table
CREATE OR REPLACE TABLE load_ny_taxi_data_dataset.external_yellow_tripdata_non_partitoned AS
SELECT * FROM `load_ny_taxi_data_dataset.external_yellow_tripdata`;

SELECT COUNT(DISTINCT(PULocationID)) FROM load_ny_taxi_data_dataset.external_yellow_tripdata_non_partitoned;

SELECT COUNT(DISTINCT(PULocationID)) FROM load_ny_taxi_data_dataset.external_yellow_tripdata_partitoned;

SELECT DISTINCT VendorID FROM `load_ny_taxi_data_dataset.external_yellow_tripdata_non_partitoned` WHERE DATE(tpep_dropoff_datetime) BETWEEN '2024-03-01' AND '2024-03-15';