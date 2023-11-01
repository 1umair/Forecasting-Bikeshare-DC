library(tidyverse)
library(ggplot2)

df <- read_csv("../Data/day.csv") |>
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

levels(df$season) <- c('winter', 'spring', 'summer', 'fall')
levels(df$workingday) <- c('weekend or holiday', 'weekday')
levels(df$weekday) <- c('Sun', 'Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat')
levels(df$holiday) <- c('non-holiday', 'holiday')
levels(df$weather) <- c('clear', 'misty', 'light rain', 'heavy rain')


# Look at daily usage of bikes on a seasonality plot
ggplot(data = df, mapping = aes(x = instant, y = total_count)) +
  geom_point(aes(color = season)) +
  labs(
    x = "Index of bike usage",
    y = "Total number of bike per day",
    color = "Season",
    title = "Review of the seasonality of bike usage"
  )

# See bike usage on a daily for day of the week
df |>
  ggplot(mapping = aes(x = instant, y = total_count)) +
    geom_point(aes(color = weekday)) +
    labs(
      x = "Index of bike usage",
      y = "Total number of bike per day",
      color = "Day of Week",
      title = "Review of the Day of the week of bike usage"
    )

# Does temperature and day of the week have an affect on the bike usage.
df |>
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
df |>
  ggplot(mapping = aes(weekday, total_count, color = season)) +
  geom_boxplot()

# How does the usage differ between holiday and non-holiday
df |>
  ggplot(mapping = aes(x = holiday, y = total_count)) +
  geom_boxplot()

# What type of weather do people typically ride the bikes?
df |>
  ggplot(mapping = aes(x = weather, y = total_count)) +
  geom_boxplot()

# Heat map of weather and weekday.
df |>
  ggplot(mapping = aes(x = weather, y = weekday, fill = total_count)) +
  geom_tile()

df |>
  ggplot(mapping = aes(x = season, y = weekday, fill = total_count)) +
  geom_tile() +
  scale_fill_distiller(palette = 'Spectral')











