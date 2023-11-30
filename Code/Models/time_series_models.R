library(tidyverse)
library(ggplot2)
library(fpp2)

# Data ----------------------------------
rm(list=ls())
fp <- file.path(getwd(), 'Other Resources', 
                'bikeshare_usage_weather_by_date.csv')
df <- read_csv(fp) |>
  select(Date, Count, TMAX, PRCP, AWND)

# Break it down from daily to weekly to see and trends and seasons better.
weekly_average <- df |>
  mutate(week = as.Date(cut(Date, "week"))) |>
  group_by(week) |>
  summarize(count = mean(Count))


# Set up TS data -------------------------
Y <- ts(weekly_average$count, start = c(2012, 12), frequency = 52)
train_Y <- subset(Y, end = 209)
test_Y <- subset(Y, start = 210)

autoplot(train_Y) +
  ggtitle("TIme Plot: Bikshare usage")

# Remove the trend
DY <- diff(train_Y)

autoplot(DY) + 
  ggtitle("Time Plot: bikeshare usage without trend")

# Is there Seasonality?
ggseasonplot(DY) +
  ggtitle("Seasonal Plot: Change in Daily Bikeshare usage")

# It is very hard to see if there is any seasonality. 

# Use benchmark method to forecast ------------------
fit <- snaive(DY)
summary(fit)
checkresiduals(fit)
# Residual sd: 1791.0014 for weekly


# Fit ETS method ------------------
# This one fails due to seasonality and too many points.
fit_ets <- ets(train_Y)
summary(fit_ets)
checkresiduals(fit_ets)
# sigma:  1384.018    ETS(A,Ad,N) 


# Fit ARIMA model ------------------
fit_arima <- auto.arima(train_Y, d=1, stepwise = FALSE, trace = TRUE)
summary(fit_arima)
checkresiduals(fit_arima)
# sigma: 1300.662     ARIMA(0,1,3)(0,1,1)[52]


# Forecast with ARIMA model -------------------------
# The best model is ARIMA (comparing sigma), therefore let's use it to forecast.
fcst <- forecast(fit_arima, h=52)


# Plot the Forecast vs Actual -------------------------
autoplot(train_Y) +
  autolayer(fcst, series = 'Forecast', alpha = 0.5) +
  autolayer(test_Y, series = 'Actual') +
  labs(
    title = "Forecast vs Actual",
    subtitle = "Bikeshare usage on weekly basis",
    x = 'Time in Weeks',
    y = 'Average Bike usage',
    caption = fcst$method
  )

# RMSE for ARIMA -------------------------
arima.rmse <- sqrt(mean((fcst$mean - test_Y)^2))
arima.rmse
# 1519.725

# Holt-Winters ---------------------
# We are still using the above Y, train_Y and test_Y

# By looking at the decomposed data, we can see that there is an obvious
# trend and seasonality. This decomposition does a better job at displaying
# the seasonality than the above plots in `Set up TS data`
decompose(Y) |>
  plot()

hw.fit <- HoltWinters(train_Y)

# Forecast out 52 weeks
hw.fcst <- forecast(hw.fit, h = 52)

autoplot(train_Y) +
  autolayer(hw.fcst, series = 'Forecast', alpha=0.5) +
  autolayer(test_Y, series = 'Actual') +
  labs(
    title = "Forecast vs Actual",
    subtitle = "Bikeshare usage on weekly basis",
    x = 'Time in Weeks',
    y = 'Average Bike usage',
    caption = "Holt-Winters"
  )

hw.rmse <- sqrt(mean((hw.fcst$mean - test_Y)^2))
hw.rmse
# 1622.855


# Linear Regression of TS -----------------
lm.fit <- tslm(train_Y ~ trend + season)

# Forecast out 52 weeks
lm.fcst <- forecast(lm.fit, h = 52)

autoplot(train_Y) +
  autolayer(lm.fcst, series = 'Forecast', alpha=0.5) +
  autolayer(test_Y, series = 'Actual')

lm.rmse <- sqrt(mean((flm$mean - test_Y)^2))
lm.rmse
# 1479.862


