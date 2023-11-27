import noaa
from datetime import date, timedelta
import pandas as pd

# import bike data 2013 - 2017
bike_data = pd.read_csv('bikeshare_usage_by_date.csv')
bike_data = bike_data.drop(columns=['Unnamed: 0'])

# get weather data 2013 - 2017
station_id = 'GHCND:USW00093738'
Token = 'TRecfmahiXwlNkfvBntIPYCQonUwNWMQ'
start_date = date(2013,1,1)
end_date = date(2017,12 ,31)
historical_weather_data = noaa.get_noaa_data(station_id, start_date, end_date, Token)
historical_weather_data = historical_weather_data.reset_index()
historical_weather_data['date'] = pd.to_datetime(historical_weather_data['date']).dt.date


#left join historical_weather_data on bike_data
bike_data['Date'] = bike_data['Date'].astype(str)
historical_weather_data['date'] = historical_weather_data['date'].astype(str)
bike_data_weather = pd.merge(bike_data,historical_weather_data, left_on='Date', right_on='date', how='left')
bike_data_weather = bike_data_weather.drop(columns=['date'])

#export to CSV
bike_data_weather.to_csv('bikeshare_usage_weather_by_date.csv')

#pull weather data for training dataset (2011-2012)
bike_data_historical = pd.read_csv('day.csv')
station_id = 'GHCND:USW00093738'
Token = 'TRecfmahiXwlNkfvBntIPYCQonUwNWMQ'
start_date = date(2011,1,1)
end_date = date(2012,12 ,31)
historical_weather_data_training = noaa.get_noaa_data(station_id, start_date, end_date, Token)
historical_weather_data_training = historical_weather_data_training.reset_index()
historical_weather_data_training['date'] = pd.to_datetime(historical_weather_data_training['date']).dt.date

#left join historical_weather_data on bike_data_historical
bike_data_historical['dteday'] = bike_data_historical['dteday'].astype(str)
historical_weather_data_training['date'] = historical_weather_data_training['date'].astype(str)
bike_data_weather_training = pd.merge(bike_data_historical,historical_weather_data_training, left_on='dteday', right_on='date', how='left')
bike_data_weather_training = bike_data_weather_training.drop(columns=['date'])
bike_data_weather_training.to_csv('days_with_weather.csv')
