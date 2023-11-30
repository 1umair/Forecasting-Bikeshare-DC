library(tidyverse)
library(ggplot2)
library(glmnet)
library(lubridate)
library(tidymodels)
library(rpart)
library(glmnet)

# Data ----------------------------------
rm(list=ls())
fp <- file.path(getwd(), 'Other Resources', 
                'bikeshare_usage_weather_by_date.csv')
df <- read_csv(fp) |>
  select(Date, Count, TMAX, PRCP, AWND) |>
  mutate(
    month = month(Date, label = TRUE),
    day = mday(Date),
    weekday = wday(Date, label = TRUE)
  )

# Break it down from daily to weekly to see and trends and seasons better.
weekly_average <- df |>
  mutate(week = as.Date(cut(Date, "week"))) |>
  group_by(week) |>
  summarize(count = mean(Count))


# Poor Linear Regression -----------------
# This is a benchmark regression model.
fit <- lm(Count ~ ., data = df)
summary(fit)
pred <- predict(fit, df)
naive.rmse <- sqrt(mean((pred - df$Count)^2))
naive.rmse
# 1553.158

# Trees ------------------

tree_spec <- decision_tree() |>
  set_engine('rpart') |>
  set_mode('regression')
# Fit the model to the training data
tree_fit <- tree_spec |>
  fit(Count ~ ., data = df)
tree_fit

# predictions
predictions <- tree_fit |>
  predict(df) |>
  pull(.pred)

metrics <- metric_set(yardstick::rsq)
model_performance <- df |>
  mutate(predictions = predictions) |>
  metrics(truth = Count, estimate = predictions)

# LASSO ---------------------

X <- df |>
  mutate(month = as.Date(cut(Date, 'month')))
  select(-Count, -Date)

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












