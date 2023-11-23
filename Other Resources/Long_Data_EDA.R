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

day$weekday <- wday(day$Date)
day$weekday <- as.factor(day$weekday)

hist(day$TMAX) # tenths of degree Celsius
hist(day$PRCP, breaks = 50) # tenths of mm
hist(day$AWND)

day |>
  ggplot(aes(Date, Count)) +
  geom_point()
# Observe the increase over time.

# As always, let's try linear regression first
lin_reg <- lm(Count ~ TMAX + PRCP + AWND + weekday + season, data = day)
summary(lin_reg)
# Adjusted R-squared 0.7175 is an improvement over linear regression run 
# on our initial dataset.
pred <- predict(lin_reg, day)
plot(day$Count)
lines(pred, col = 'red')
# Obviously, we can see linear regression overestimating usage in the first year 
# and underestimating in the last year of out dataset

# Reusing Josh's Code for Holt-Winters
dfts <- ts(day$Count, frequency = 365, start = c(2013, 01,01))
components_dfts <- decompose(dfts)
plot(components_dfts)

hw1 <- HoltWinters(dfts)
plot(dfts)
lines(hw1$fitted[,1], col = 'blue')

hw1.pred <- predict(hw1, 730, prediction.interval = TRUE, level = 0.95)
plot(dfts, xlim=c(2013, 2020))
lines(hw1$fitted[,1], col = 'blue')
lines(hw1.pred[,1], col = 'red')
lines(hw1.pred[,2], col = 'orange')
lines(hw1.pred[,3], col = 'orange')

# Holt-Winters error bars are still really wide, and the prediction appears underfit