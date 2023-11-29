library(tidyverse)
library(ggplot2)
library(fpp2)
library(forecast)

# Read the dataset
fp <- read.csv("C:/Users/danie/Downloads/Team-10-main/Team-10-main/Data/days_with_weather.csv", header = TRUE)

library(dplyr)

# Convert 'dteday' column to Date format if it's not already
fp$dteday <- as.Date(fp$dteday)

# Aggregate daily data to weekly using dplyr
weekly_data <- fp %>%
  group_by(year_week = format(dteday, "%Y-%U")) %>%  # Group by year and week
  summarise(average_cnt = mean(cnt),                # Calculate average count for the week
            average_temp = mean(temp),              # Calculate average temperature
            average_hum = mean(hum),                # Calculate average humidity
            average_windspeed = mean(windspeed),    # Calculate average windspeed
            total_casual = sum(casual),             # Calculate total casual counts
            total_registered = sum(registered)      # Calculate total registered counts
            # Add more aggregations as needed
  )

# View the structure of the weekly data
head(weekly_data)


# Assuming 80% for training and 20% for testing
train_rows <- round(0.8 * nrow(weekly_data))

# Splitting the data
train_data <- weekly_data[1:train_rows, ]
test_data <- weekly_data[(train_rows + 1):nrow(weekly_data), ]

# Fit SARIMA model to the training data
sarima_model <- Arima(train_data$average_cnt, order = c(1, 0, 1), seasonal = list(order = c(1, 0, 1), period = 52))


# Forecast using the SARIMA model
sarima_forecast <- forecast(sarima_model, h = nrow(test_data))

# View the forecast
print(sarima_forecast)

# Calculate rsme
rmse <- sqrt(mse)
cat("Root Mean Squared Error (RMSE): ", rmse, "\n")


# Convert test_data to a time series
test_ts <- ts(test_data$average_cnt, frequency = 52)
train_ts <- ts(train_data$average_cnt, frequency = 52)

# Convert sarima_forecast to a time series 
sarima_forecast_ts <- ts(sarima_forecast$mean, frequency = 52)


# Plot observed vs forecast 
autoplot(test_ts) +
  autolayer(sarima_forecast_ts, series = "Forecast") +
  labs(x = "Time", y = "Average Count", title = "SARIMA Forecast vs Observed") +
  theme_minimal() +  # Change the plot theme to minimal
  theme(plot.title = element_text(hjust = 0.5),  # Center plot title
        legend.position = "bottom") +  # Change legend position
  scale_color_manual(values = c("blue", "red"))  # Custom colors for observed and forecasted data


# Forecast error plot
autoplot(sarima_forecast) +
  autolayer(test_ts, series = "Observed") +
  labs(x = "Time", y = "Average Count", title = "SARIMA Forecast vs Observed") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5), legend.position = "bottom")

