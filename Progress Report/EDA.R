setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

suppressMessages(library(tidyverse))

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
