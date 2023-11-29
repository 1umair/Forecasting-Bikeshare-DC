library(tidyverse)
library(ggplot2)
library(caret)
library(glmnet)



# Data -------------------------

day <- read_csv("./Data/day.csv") |>
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
levels(day$season) <- c('winter', 'spring', 'summer', 'fall')
levels(day$workingday) <- c('weekend or holiday', 'weekday')
levels(day$weekday) <- c('Sun', 'Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat')
levels(day$holiday) <- c('non-holiday', 'holiday')
levels(day$weather) <- c('clear', 'misty', 'light rain', 'heavy rain')

head(day)

day_cnt <- day |>
  select(season:windspeed, total_count, -yr, -mnth)


# Basic Classification ------------------
X <- day_cnt |> select(-weekday)
y <- day_cnt$weekday
cv_fit <- cv.glmnet(x = as.matrix(X), 
                    y = y, 
                    nfolds = 10, 
                    type.measure = 'class', 
                    family = 'multinomial',
                    alpha = 0,
                    # grouped = FALSE
                    )

cv_fit$lambda.min
fit <- glmnet(x = as.matrix(X), y = y, alpha = 0, family='multinomial', lambda = cv_fit$lambda.min)

y_pred <- predict(fit, newx = X, response='class')







