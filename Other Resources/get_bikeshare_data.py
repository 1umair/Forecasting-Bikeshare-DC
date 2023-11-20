import pandas as pd
import requests
import re
import os
from zipfile import ZipFile  

zip_list = ['2013-capitalbikeshare-tripdata.zip',
'2014-capitalbikeshare-tripdata.zip',
'2015-capitalbikeshare-tripdata.zip',
'2016-capitalbikeshare-tripdata.zip',
'2017-capitalbikeshare-tripdata.zip']

url_prefix = 'https://s3.amazonaws.com/capitalbikeshare-data/'

def download_zip(url_prefix, name):
    full_url = url_prefix + name
    request = requests.get(full_url)
    with open(name, "wb") as f:
        f.write(request.content)
    with ZipFile(name) as zip_archive:
        zip_archive.extractall()

for z in zip_list:
    download_zip(url_prefix, z)

csv_files = [i for i in os.listdir() if re.findall(r'\.csv', i)]
zip_files = [i for i in os.listdir() if re.findall(r'\.zip', i)]

df_list = []

for c in csv_files:
    my_df = pd.read_csv(c)
    df_list.append(my_df)

main_df = pd.concat(df_list)

main_df['Start date'] = main_df['Start date'].astype('datetime64[ns]')
main_df['Date'] = main_df['Start date'].dt.date
main_df['Hour'] = main_df['Start date'].dt.hour

date_df = pd.DataFrame(main_df.groupby('Date')['Duration'].count())
date_df = date_df.reset_index()
date_df.columns = ['Date', 'Count']

date_df.to_csv('bikeshare_usage_by_date.csv')

hour_df = pd.DataFrame(main_df.groupby(['Date', 'Hour'])['Duration'].count().reset_index())
hour_df.columns = ['Date', 'Hour', 'Count']

hour_df.to_csv('bikeshare_usage_by_date_and_hour.csv')

for c in csv_files:
    os.remove(c)

for z in zip_files:
    os.remove(z)