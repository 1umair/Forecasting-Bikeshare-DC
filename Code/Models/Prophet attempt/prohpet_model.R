library(tidyverse)
library(ggplot2)
library(fpp2)
library(prophet)

# Data ----------------------------------
rm(list=ls())
fp <- read.csv("C:/Users/danie/Downloads/Team-10-main/Team-10-main/Data/days_with_weather.csv", header= TRUE)

# Prepare data for Prophet
df_prophet <- fp %>%
  select(dteday, cnt) %>%
  rename(ds = dteday, y = cnt)  # Rename columns as 'ds' for date and 'y' for values to forecast

# Convert 'ds' to proper date format if needed
df_prophet$ds <- as.Date(df_prophet$ds)

# Initialize Prophet model
prophet_model <- prophet()

# Fit the model
prophet_model <- fit.prophet(prophet_model, df_prophet)

# Make future predictions
future <- make_future_dataframe(prophet_model, periods = 365)  # Change the number of periods as needed

forecast <- predict(prophet_model, future)

# Plot the forecast
plot(prophet_model, forecast)

# Assuming 'fp' is your dataset containing the actual values
actual_values <- fp$cnt  # Replace 'cnt' with the column name containing actual values

# Get the predicted values from the Prophet forecast
predicted_values <- forecast$yhat[-(1:length(actual_values))]  # Use forecasted values excluding the training data

# Calculate RMSE and MAE
rmse <- sqrt(mean((actual_values - predicted_values)^2))
mae <- mean(abs(actual_values - predicted_values))

# Print RMSE and MAE
print(paste("RMSE:", rmse))
print(paste("MAE:", mae))
