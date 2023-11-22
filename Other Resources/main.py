import noaa
from datetime import date, timedelta
import pandas as pd

# import bike data 2013 - 2017
bike_data = pd.read_csv('bikeshare_usage_by_date.csv')

# get weather data 2013 - 2017
station_id = 'GHCND:USW00093738'
Token = 'TRecfmahiXwlNkfvBntIPYCQonUwNWMQ'
start_date = date(2013,1,1)
end_date = date(2013,12 ,31)
historical_weather_data = noaa.get_noaa(station_id, start_date, end_date, Token)
historical_weather_data