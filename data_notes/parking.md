### Parking Data
#### Files:

* Parking_Info.csv (http://opendata.itsmarta.com/hackathon/2017/February/Parking_Data/Parking_Info.csv)
* Station.csv (http://opendata.itsmarta.com/hackathon/2017/February/Parking_Data/Station.csv)

#### Fields

* Parking_Info.csv / Station.csv

     (joining these two datasets into one by STATION_ID)
     * **ID**
          * Row ID for parking dataset
     * **STATION_ID**
          * 1 through 23
     * **YEAR** / **MONTH**
          * Starts with 2007/7; goes through 2016/12
     * **NUMBER_OF_CARS_PARKED**
          * 0-2384
          * NA in 365 out of 2622 rows (13.9%) - due to STATION_ID being listed for a year/month combination, but no parking data
     * **PERCENT_FILLED**
          * NUMBER_OF_CARS_PARKED / NUMBER_OF_SPACES (latter is in station dataset)
     * **STATION_NAME**
     * **NUMBER_OF_SPACES**