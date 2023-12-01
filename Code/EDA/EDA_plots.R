library(tidyverse)
library(ggplot2)
require(gridExtra)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# This will import the original data and convert some of the columns to factors.
day <- read_csv("../../Data/day.csv") |>
  rename(
    weather = weathersit,
    total_count = cnt
  ) |>
  mutate(
    season = factor(season),
    holiday = as.factor(holiday),
    weekday = as.factor(weekday),
    workingday = as.factor(workingday),
    weather = as.factor(weather)
  )
# Setting values for the factor's levels
levels(day$season) <- c('winter', 'spring', 'summer', 'fall')
levels(day$workingday) <- c('weekend or holiday', 'weekday')
levels(day$weekday) <- c('Sun', 'Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat')
levels(day$holiday) <- c('non-holiday', 'holiday')
levels(day$weather) <- c('clear', 'misty', 'light rain', 'heavy rain')

temp <- day |>
  ggplot() +
  geom_histogram(mapping = aes(temp, fill="Actual"), alpha = 0.5) +
  geom_histogram(mapping = aes(atemp, fill= "Feels Like"), alpha = 0.5) +
  scale_fill_manual("Temperature", values = c("red", "blue")) +
  labs(
    x = "Normalized Temperature (C)",
    y = "Density",
    title = "Histogram of Normalized Temperature in Celcius",
    subtitle = "Feels and Actual Temperature",
  )

hum <- day |>
  ggplot() +
  geom_histogram(mapping = aes(hum)) +
  labs(
    x = "Normalized Humidity",
    y = "Density",
    title = "Histogram of Normalized Humidity"
  )

ws <- day |>
  ggplot(mapping = aes(windspeed)) +
  geom_histogram() +
  labs(
    x = "Normalized Wind Speed",
    y = "Density",
    title = "Histogram of Normalized Wind Speed"
  )
grid.arrange(hum, ws, ncol=2)
temp

day |>
  ggplot() +
  geom_histogram(mapping = aes(total_count, fill="Total"), alpha = 0.5) +
  geom_histogram(mapping = aes(casual, fill="Casual"), alpha = 0.5) +
  geom_histogram(mapping = aes(registered, fill= "Registered"), alpha = 0.5) +
  scale_fill_manual("Rider Type", values = c("green", "red", "blue")) +
  labs(
    x = "Bike Usage per Day",
    y = "Density",
    title = "Total vs Casual vs Registered Users"
  )

# Look at daily usage of bikes on a seasonality plot
ggplot(data = day, mapping = aes(x = instant, y = total_count)) +
  geom_point(aes(color = season)) +
  labs(
    x = "Index of bike usage",
    y = "Total number of bike per day",
    color = "Season",
    title = "Review of the seasonality of bike usage"
  )

# See bike usage on a daily for day of the week
day |>
  ggplot(mapping = aes(x = instant, y = total_count)) +
    geom_point(aes(color = weekday)) +
    labs(
      x = "Index of bike usage",
      y = "Total number of bike per day",
      color = "Day of Week",
      title = "Review of the Day of the week of bike usage"
    )

# Does temperature and day of the week have an affect on the bike usage.
day |>
  ggplot(mapping = aes(x = instant, y = temp)) +
  geom_point(aes(color = weekday, size = total_count / 1000)) +
  scale_size_continuous() +
  labs(
    x = "Index of bike usage",
    y = "Bike usage based on Normalized Temperature",
    color = "Day of Week",
    size = "Total Bikes (per 1k)",
    title = "How temperature and day of the week affect bike usage."
  )

# How does the usage for all seasons look based on day of the week
day |>
  ggplot(mapping = aes(weekday, total_count, color = season)) +
  geom_boxplot()

# How does the usage differ between holiday and non-holiday
day |>
  ggplot(mapping = aes(x = holiday, y = total_count)) +
  geom_boxplot()

# What type of weather do people typically ride the bikes?
day |>
  ggplot(mapping = aes(x = weather, y = total_count)) +
  geom_boxplot()

# Heat map of weather and weekday.
day |>
  ggplot(mapping = aes(x = weather, y = weekday, fill = total_count)) +
  geom_tile()
# According to the above, we can see that there doesn't appear to be any light
# rain on Friday with Usage.

day |>
  ggplot(mapping = aes(x = season, y = weekday, fill = total_count)) +
  geom_tile() +
  scale_fill_distiller(palette = 'Spectral')


fit <- lm(total_count ~ ., day)
summary(fit)

# Hourly -------
# Run the  same info above, but look at hourly instead.
df_h <- read_csv("../../Data/hour.csv") |>
  rename(
    weather = weathersit,
    total_count = cnt
  ) |>
  mutate(
    season = factor(season),
    holiday = as.factor(holiday),
    weekday = as.factor(weekday),
    workingday = as.factor(workingday),
    weather = as.factor(weather)
  )

levels(df_h$season) <- c('winter', 'spring', 'summer', 'fall')
levels(df_h$workingday) <- c('weekend or holiday', 'weekday')
levels(df_h$weekday) <- c('Sun', 'Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat')
levels(df_h$holiday) <- c('non-holiday', 'holiday')
levels(df_h$weather) <- c('clear', 'misty', 'light rain', 'heavy rain')


# Look at daily usage of bikes on a seasonality plot
ggplot(data = df_h, mapping = aes(x = instant, y = total_count)) +
  geom_point(aes(color = season)) +
  labs(
    x = "Index of bike usage",
    y = "Total number of bike per day",
    color = "Season",
    title = "Review of the seasonality of bike usage"
  )

# See bike usage on a daily for day of the week
df_h |>
  ggplot(mapping = aes(x = instant, y = total_count)) +
  geom_point(aes(color = weekday)) +
  labs(
    x = "Index of bike usage",
    y = "Total number of bike per day",
    color = "Day of Week",
    title = "Review of the Day of the week of bike usage"
  )

# Does temperature and day of the week have an affect on the bike usage.
df_h |>
  ggplot(mapping = aes(x = instant, y = temp)) +
  geom_point(aes(color = weekday, size = total_count / 1000)) +
  scale_size_continuous() +
  labs(
    x = "Index of bike usage",
    y = "Bike usage based on Normalized Temperature",
    color = "Day of Week",
    size = "Total Bikes (per 1k)",
    title = "How temperature and day of the week affect bike usage."
  )

# How does the usage for all seasons look based on day of the week
df_h |>
  ggplot(mapping = aes(weekday, total_count, color = season)) +
  geom_boxplot() +
  labs(
    x = "Weekday",
    y = "Total Bike Usage",
    title = "Total Bike Usage",
    subtitle = "Given Weekday and Season"
  )

registered <- df_h |>
  ggplot(mapping = aes(x = weekday, y = registered, color = season)) +
  geom_boxplot() +
  labs(
    x = "",
    y = "Registered Users",
    title = "Registered Users vs Casual Users",
    subtitle = "Based on Weekday and Seasonality"
  ) +
  theme(
    axis.text.x = element_blank()
  )
casual <- df_h |>
  ggplot(mapping = aes(x = weekday, y = casual, color = season)) +
  geom_boxplot() +
  labs(
    x = "Weekday",
    y = "Casual Users"
  )
grid.arrange(registered, casual, nrow=2)

# How does the usage differ between holiday and non-holiday
df_h |>
  ggplot(mapping = aes(x = holiday, y = total_count)) +
  geom_boxplot()

# What type of weather do people typically ride the bikes?
df_h |>
  ggplot(mapping = aes(x = weather, y = total_count)) +
  geom_boxplot()

# What about causal riders vs registered riders
df_h |>
  ggplot() +
  # geom_boxplot(mapping = aes(x = weekday, y = casual, color = season)) #+
  geom_boxplot(mapping = aes(x = weekday, y = registered, color = season))

# Heat map of weather and weekday.
df_h |>
  ggplot(mapping = aes(x = weather, y = weekday, fill = total_count)) +
  geom_tile()

df_h |>
  ggplot(mapping = aes(x = season, y = weekday, fill = total_count)) +
  geom_tile() +
  scale_fill_distiller(palette = 'Spectral')

df <- df_h |>
  select(
    -mnth, -hr, -yr, -casual, -registered, -dteday, -instant
  )
  

fit <- lm(total_count ~ ., df)
summary(fit)



