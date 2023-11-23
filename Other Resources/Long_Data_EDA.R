library(tidyverse)
library(ggplot2)
require(gridExtra)
library(lubridate)


setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

usage_date <- read_csv('bikeshare_usage_weather_by_date.csv')
day <- usage_date %>% select(Date, Count, TMAX, PRCP, AWND)

day$month <- format(as.Date(day$Date, format="%d/%m/%Y"),"%m")
day$day <- format(as.Date(day$Date, format="%d/%m/%Y"),"%d")

day$season = cut(lubridate::yday(day$Date - lubridate::days(79)), 
    breaks = c(0, 93, 187, 276, Inf), 
    labels = c("Spring", "Summer", "Autumn", "Winter"))

