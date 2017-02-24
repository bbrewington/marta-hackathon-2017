library(readr); library(dplyr); library(stringr); library(lubridate)

## Get apc data (North Avenue corridor) ----
apcdata <- read_csv("data_raw/opendata.itsmarta.com/apcdata_NorthAve.csv",
                    col_types = "ccccccccccccc")

apcdata1 <- apcdata %>% mutate(calendar_day2 = mdy(calendar_day),
                               route2 = as.integer(route),
                               ons = as.integer(ons),
                               offs = as.integer(offs),
                               latitude = as.numeric(latitude),
                               longitude = as.numeric(longitude))

apcdata1 %>% summarise(day1 = min(calendar_day2), day2 = max(calendar_day2))
apcdata1 %>% arrange(route2) %>% .$route2 %>% unique()

## Get avl data ----
avl_week <- read_csv("data_raw/opendata.itsmarta.com/avl_otpdata_week.csv", 
                     col_types = paste(rep("c", times = 19), collapse = ""))
avl_month <- read_csv("data_raw/opendata.itsmarta.com/avl_otpdata_month.csv",
                      col_types = paste(rep("c", times = 19), collapse = ""))
avl_year <- read_csv("data_raw/opendata.itsmarta.com/avl_otpdata_year.csv",
                     col_types = paste(rep("c", times = 19), collapse = ""))

avl_week1 <- 
     avl_week %>%
     mutate(calendar_day = dmy(calendar_day),
            scheduled_time = as.integer(scheduled_time),
            actual_arrival_time = as.integer(actual_arrival_time),
            actual_depart_time = as.integer(actual_depart_time),
            adherence_seconds = as.integer(adherence_seconds),
            latitude = as.numeric(latitude) / 10000000,
            longitude = as.numeric(longitude) / 10000000)

avl_week1$adherence_category <- 
     cut(avl_week1$adherence_seconds, breaks = c(-10000, -300, 300, 10000))

summary(dmy(avl_week$calendar_day))
summary(dmy(avl_month$calendar_day))
summary(dmy(avl_year$calendar_day))
ncol(avl_week)

## Get Parking Data ----
parking <- read_csv("data_raw/opendata.itsmarta.com/Parking_Info.csv", col_types = "cccccc")
station <- read_csv("data_raw/opendata.itsmarta.com/Station.csv", col_types = "ccc")
parking2 <- parking %>% left_join(station, by = c("STATION_ID"))
