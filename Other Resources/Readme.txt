=========================
OTHER RESOURCES
=========================

The Data folder contains datasets and code used in our analysis. Below are our datasets and their descriptions. 

========
DATASETS
========

1) bikeshare_usage_by_date.csv: This dataset tracks the daily bike share count from 2013 to 2017 in the Capital bikeshare system. 

2) bikeshare_usage_weather_by_date.csv: This dataset tracks is the same data as bikeshare_usage_by_date.csv with the addition of maximum temperature, average windspeed, and precipitation. 

3) day.csv: This dataset tracks the daily bike share count from 2011 to 2012 in the Capital bikeshare system. 

4) days_with_weather.csv: dataset tracks the daily bike share count from 2011 to 2012 in the Capital bikeshare system with the addition of maximum temperature, average windspeed, and precipitation.


5) dc_stations.csv: this dataset shows the different NOAA weather stations and station ids in the dc metro area.


========
CODE
========

1) get_bikeshare_data.py: this python script pulls capital bike share data for 2013-2017.

2) nooa.py: this python script has a function that pings the NOAA API for the maximum temperature, average windspeed, and precipitation.

3) join_data.py: this python script performs left joins on the 2013-2017 and 2011-2012 datasets to include the columns pulled from noaa.py. 