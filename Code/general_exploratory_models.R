library(tidyverse)
library(ggplot2)

# What days is demand low? 
# Can we specifically target those days to perform repairs?

# fp <- file.path('./', 'Data', 'day.csv')

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
  select(season:windspeed, total_count)

# Poor Linear Regression -----------------
day_cnt <- day |>
  select(-instant, -dteday, -casual, -registered, -yr, -mnth) |>
  select(-workingday, -atemp, -holiday, -weekday)

fit <- lm(total_count ~ ., data = day_cnt)
summary(fit)

pred <- predict(fit, day_cnt)

# Holt-Winters TS -----------------
# This doesn't appear to be that accurate. We can see by the confidence intervals
# in orange that we aren't sure at all. It also seems to repeat the first
# couple of years with an upward trend. This just means there isn't enough
# data to perform a time series Holt-Winters method against.

day |>
  group_by(season) |>
  count()


day |>
  ggplot(aes(dteday, total_count)) +
  geom_line()


dfts <- ts(day$total_count, frequency = 365, start = c(2011, 01,01))
dfts

components_dfts <- decompose(dfts)
plot(components_dfts)


hw1 <- HoltWinters(dfts)
plot(dfts)
lines(hw1$fitted[,1], col = 'blue')

hw1.pred <- predict(hw1, 730, prediction.interval = TRUE, level = 0.95)
plot(dfts, xlim=c(2011, 2015))
lines(hw1$fitted[,1], col = 'blue')
lines(hw1.pred[,1], col = 'red')
lines(hw1.pred[,2], col = 'orange')
lines(hw1.pred[,3], col = 'orange')


# Trees ------------------

library(tidymodels)
library(rpart)

tree_spec <- decision_tree() |>
  set_engine('rpart') |>
  set_mode('regression')
# Fit the model to the training data
tree_fit <- tree_spec |>
  fit(total_count ~ ., data = day_cnt)
tree_fit

# predictions
predictions <- tree_fit |>
  predict(day_cnt) |>
  pull(.pred)

metrics <- metric_set(yardstick::rsq)
model_performance <- day_cnt |>
  mutate(predictions = predictions) |>
  metrics(truth = total_count, estiamte = predictions)

# LASSO ---------------------

library(glmnet)

X <- read_csv("./Data/day.csv") |>
  rename(
    weather = weathersit,
    total_count = cnt
  ) |>
  mutate(
    winter = as.numeric(season == 1),
    spring = as.numeric(season == 2),
    summer = as.numeric(season == 3),
    fall = as.numeric(season == 4),
    nworkday = as.numeric(workingday == 0),
    workday = as.numeric(workingday == 1),
    sunday = as.numeric(weekday == 0),
    monday = as.numeric(weekday == 1),
    tuesday = as.numeric(weekday == 2),
    wednesday = as.numeric(weekday == 3),
    thursday = as.numeric(weekday == 4),
    friday = as.numeric(weekday == 5),
    saturday = as.numeric(weekday == 6),
    clear = as.numeric(weather == 1),
    misty = as.numeric(weather == 2),
    light_rain = as.numeric(weather == 3),
    heavy_rain = as.numeric(weather == 4)
  ) |>
  select(
    winter, spring, summer, fall, nworkday, workday, sunday, monday, tuesday, 
    wednesday, thursday, friday, saturday, clear, misty, light_rain, heavy_rain, 
    yr, mnth, temp, atemp, hum, windspeed
  )

X <- as.matrix(X)
y <- day_cnt$total_count
cv_mod <- cv.glmnet(X, y, alpha = 1)
best_lambda <- cv_mod$lambda.min
best_lambda
plot(cv_mod)

best_model <- glmnet(X, y, alpha = 1, lambda = best_lambda)
coef(best_model)

y_pred <- predict(best_model, s = best_lambda, newx = X)

sst <- sum((y - mean(y))^2)
sse <- sum((y_pred - y)^2)
rsq <- 1 - sse / sst
rsq

