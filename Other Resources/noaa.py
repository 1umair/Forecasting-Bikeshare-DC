import requests
from datetime import date, timedelta
import pandas as pd

#1) find station_id in washington DC
#FIPS is 11 for District of Columbia
Token = 'TRecfmahiXwlNkfvBntIPYCQonUwNWMQ'
r = requests.get('https://www.ncei.noaa.gov/cdo-web/api/v2/stations?locationid=FIPS:11', headers={'token': Token})
dic = r.json()
dic = dic.pop("results")
new_data = pd.DataFrame.from_dict(dic, orient='columns')
# saving new_data into a csv file
new_data.to_csv('dc_stations.csv') #shows the possible NOAA stations

#Dulles USW00093738
#WASHINGTON 2.0 SSW US1DCDC0009
#WASHINGTON 5.1 NW   GHCND:US1DCDC0014
def get_noaa_data(station_id, start_date, end_date, token):
    # station_id = 'GHCND:USW00093738'
    # start_date = date(2020,1,1)
    # end_date = date(2020, 1,2)
    # returns a pandas dataframe with date, Average temperature (tenths of degrees C), Precipitation (tenths of mm),  and
    delta = timedelta(days=1)
    weather_data = pd.DataFrame()
    while start_date <= end_date:
        start = start_date.strftime("%Y-%m-%d")
        end = end_date.strftime("%Y-%m-%d")
        start_date += delta
        url = f"http://www.ncdc.noaa.gov/cdo-web/api/v2/data?datasetid=GHCND&stationid={station_id}&startdate={start}&enddate={start}"
        headers = {"token":Token}
        r = requests.get(url, "dataset", headers=headers)
        dic = r.json()
        dic = dic.pop("results")
        data = pd.DataFrame.from_dict(dic)
        new_data = data[['date', 'datatype', 'value']].pivot(index='date', columns='datatype')
        new_data = new_data['value']
        new_data.columns.name = None
        weather_data = pd.concat([weather_data,new_data[['TAVG', 'PRCP','AWND']]])
    return weather_data

