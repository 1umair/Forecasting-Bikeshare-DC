# Team-10

Bike sharing systems are an increasingly popular solution in major urban areas to increase the usage of bicycles as a mode of transport. Bike usage improves the lives of users by providing exercise, but also helps non-users since more trips taken by bike leads to a reduction in the number of cars on the road and $CO_2$ emissions. We studied usage data from Washington DC's Capital Bikeshare from 2011 to 2017 and corresponding weather data. 

The purpose of this analysis is to determine variables/factors that help estimate bike usage and develop a model that forecasts the usage based on weather, day of week, and season.

# Overview of Project

The idea of the project was to use different modeling techniques to determine if we could forecast the bike usage. If we are able to model and forecast bikeshare usage, then it would allow Capital Bikeshare (or any agency/company running a bikesharing program) to plan for the best times to increase their fleet as well as expanding the available stations that are offered. A station is a location where the bikes are stored and can be rented.

Some of the questions were: 

* Can we use the data to forecast when our usage is lower to potentially remove some bikes from service for maintenance? 
* When should we start increasing our fleet to best meet demand? 
* Do weather or seasons have an impact on usage? 

We made an initial hypothesis that we would see a higher usage during the summer, and when the weather was nice (moderate temperature, no precipitation, low windspeed). Initial exploratory data analysis (EDA) indicated that these hypotheses appeared true. Usage tends to be highest in spring and summer, and usage generally increases as temperature increases, and decreases as precipitation and windspeed increase. However, in addition to pronounced seasonality, we identified that there was a trend towards increased usage of the system over time. The question then became, can we model this through a time series model? Also, could we see what features were key factors in determining bike usage. Which factors overall appear to have the greatest impact?


# Python Scripts to Scrape and Aggregate Data

* Consider setting up a virtual environment first.
* Install necessary packages by running `pip install requirements.txt`
* In the `Other Resources` directory, first run `get_bikeshare_data.py`, then run `join_data.py`. This will retrieve additional years of bikeshare data and add historical weather data.

# R Scripts for Data Cleaning and Analysis
* There are two subfolders with the R scripts, both located in the 'Code' directory. 

In the 'Model' subfolder:
* Run `Combinedmodels.R` and `regression_models.R`, `time_series_models.R` ,`prohpet_model.R` and `sarima_model.R` to see different models.

In the 'EDA' subfolder:
* Run `EDA_plots.R` and `EDA.R` to see models and visuals used in exploratory data analysis