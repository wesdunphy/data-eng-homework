with 

source as (

    select * from {{ source('staging', 'fhv_trip_data') }}
    where dispatching_base_num IS NOT NULL

)

select
   dispatching_base_num,
   pickup_datetime,
   dropoff_datetime,
   pulocationid AS pickup_locationid,
   dolocationid AS dropoff_locationid,
   sr_flag,
   affiliated_base_number
from source
