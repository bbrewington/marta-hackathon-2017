### APC Data
#### Filenames:

* avl_otpdata_week.csv
* avl_otpdata_month.csv
* avl_otpdata_year.csv

#### Paths:

* http://opendata.itsmarta.com/hackathon/2017/February/AVL_OTP/avl_otpdata_week.csv
* http://opendata.itsmarta.com/hackathon/2017/February/AVL_OTP/avl_otpdata_month.csv
* http://opendata.itsmarta.com/hackathon/2017/February/AVL_OTP/avl_otpdata_year.csv


#### Fields
* **calendar_day**
     * Format "DD-MMM-YY" (where MMM is the 3-character abbreviated month, like JAN)
     * Timeframes
          * avl_otpdata_week.csv: 02-JAN-17 (Monday) to 08-JAN-17 (Sunday)
          * avl_otpdata_month.csv: 01-JAN-17 to 31-JAN-17
          * avl_otpdata_year.csv: 01-JAN-16 to 31-JAN-17
* **scheduled_time**
     * Corresponds with the "departure_time" in the GTFS "stop_times.txt" entity (for more info, see https://developers.google.com/transit/gtfs/reference/stop_times-file)
     * Units: seconds from midnight, where midnight is defined as noon minus 12 hours (allows for some values > 24 b/c daylight savings time...see link above for more info)
     * Min: 15300, Max: 91800
* **actual_arrival_time**
     * Same units as scheduled_time; see above
     * Min: 14300, Max: 92870
* **actual_depart_time**
     * Same units as scheduled_time; see above for more info
     * Min: 14740, Max: 92870
* **adherence_seconds**
     * **scheduled_time** - **actual_depart_time**
     * negative values mean departure was late; positive values mean departure was early
* **time_point_id / time_point_name**
     * Min: 2, Max: 835
     * Unique Values:
          * time_point_id: 396
          * time_point_name: 393
* **block_stop_order**
     * Unique Values: 2189
* **vehicle_num**
     * Unique Values: 2189
     * 4 digit unique ID for vehicles
     * Split into 2 groups: 1401-1718 & 2191-2596
* **geo_node**
     * unique ID for latitude/longitude combination
* **latitude / longitude**
     * Actual lat/lon values times 10,000,000 (divide by 10M to convert to usable format)
* **schd_distance**
* **route_abbr**
     * Unique Values: 103
* **block_abbr**
* **is_layover**
     * logical, value can be either 0 or 1
* **route_name**
     * Unique Values: 116
* **isrevenue**
     * All are equal to 1
* **revenue_id**
     * R or D