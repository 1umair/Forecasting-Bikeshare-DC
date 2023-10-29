setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

suppressMessages(library(tidyverse))
suppressMessages(library(corrplot))

day <- read_csv('../Data/day.csv')

head(day)
# Notice that tidyverse has already recognized the dteday column as a date, which is helpful.

# Check for any NA values - we do not find any, which is good:
sapply(day, function(x)all(any(is.na(x))))

# According to documentation, instant is just row index, and we have a lot of factor variables, so let's
# transform the dataset accordingly

day_cleaned <- day[-1] %>% mutate(season = as.factor(season)) %>%
  mutate(holiday = as.factor(holiday)) %>%
  mutate(weekday = as.factor(weekday)) %>%
  mutate(workingday = as.factor(workingday)) %>%
  mutate(weathersit = as.factor(weathersit))

day_cleaned 

summary(day_cleaned)

# Let's look at distribution of our numeric variables as well. First the predictors - weather:
hist(day_cleaned$temp)
hist(day_cleaned$atemp)
hist(day_cleaned$hum)
hist(day_cleaned$windspeed)
# Now the likely dependent user variables.
hist(day_cleaned$casual) # Notice the heavy skew
hist(day_cleaned$registered) # Closer to a normal distribution than 'casual'
# Possibly this indicates we might want two separate models for casual and registered.
hist(day_cleaned$cnt)

# Look at weather predictor variable correlations
numeric_weather_predictors <- day_cleaned %>% select(temp, atemp, hum, windspeed)
cor(numeric_weather_predictors)
corrplot(cor(numeric_weather_predictors))
#' Logically, atemp is correlated heavily with temp, and windspeed has negative correlation
#' with the other factors.

# Look at correlations between the respone variables for usage:
numeric_users <- day_cleaned %>% select(casual, registered, cnt)
cor(numeric_users)
corrplot(cor(numeric_users))

# Some boxplot visualiations

# Holiday usage: lower on average, but wide variance
boxplot(cnt ~ holiday, data = day_cleaned)

# Weekday usage: slightly higher on average midweek, which surprised me
boxplot(cnt ~ weekday, data = day_cleaned)

# Working day vs non-working day usage - more variance on non-working days
boxplot(cnt ~ workingday, data = day_cleaned)

# Seasonality: Note that usage is much lower for season 1. In the readme.txt
# file, they claim that 1 is for spring, but this is a mistake. 1 is used for winter (21 Dec through 20 Mar)
# With 2 for Spring, 3 for Summer, 4 for Fall.
boxplot(cnt ~ season, data = day_cleaned)
# Usage is slightly higher in summer.
