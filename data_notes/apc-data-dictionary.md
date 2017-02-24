### APC Data
Filename: apcdata_NorthAve.csv
Path: http://opendata.itsmarta.com/hackathon/2017/February/APC/apcdata_NorthAve.csv

#### Fields

* **calendar_day:** MM/DD/YYYY
     * From 01/01/2017 to 02/01/2017 (32 days)
* **route:** ID for (bus?) route
     * 21 Unique values: 1, 2, 4, 6, 9, 16, 21, 26, 32, 53, 74, 95, 99, 102, 107, 109, 110, 191, 192, 193, 194
* **route_name:** route + route description.  Also 21 unique values.
* **direction:** Northbound, Westbound, Southbound, Eastbound
* **stop_id:** 6 digit number, 151 different stops
* **stop_name:** name of the stop (typically 2 cross-streets)
     * not a unique identifier of the stop.  Must use stop_id if need a unique ID (there are 39 stop_names that are repeated across multiple stop_id's)
* **arrival_time:** Format HH:MM:SS (contains some blanks)
* **departure_time:** Format HH:MM:SS (contains some blanks)

#### Data Quality Notes

* 169,127 rows total
     * 0.23% have a blank in either arrival_time or departure_time
          * 0.11% & 0.12%, respectively
     * 28.6% have data in both arrival_time and departure_time
     * 71.2% have blanks in both