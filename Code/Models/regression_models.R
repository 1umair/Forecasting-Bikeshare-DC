library(tidyverse)
library(ggplot2)
library(glmnet)
library(lubridate)
library(tidymodels)
library(rpart)
library(glmnet)
set.seed(123)

# Data ----------------------------------
rm(list=ls())
fp <- file.path(getwd(), 'Data', 'final_df.csv')
df <- read_csv(fp) |>
  mutate(
    season = factor(season),
    day_of_week = factor(day_of_week)
  ) |>
  select(-mnth_date, -...1, -dteday)
levels(df$season) <- c('winter', 'spring', 'summer', 'fall')
levels(df$day_of_week) <- c('Sun', 'Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat')


# Poor Linear Regression -----------------
# This is a benchmark regression model.
fit <- lm(cnt ~ ., data = df)
summary(fit)
pred <- predict(fit, df)
naive.rmse <- sqrt(mean((pred - df$cnt)^2))
naive.rmse
# 2632.675
df |>
  ggplot(mapping = aes(x=1:length(cnt), y = cnt)) +
  geom_line() + 
  geom_line(mapping = aes(y = pred), col = 'red', alpha = 0.5) +
  labs(
    x = 'Date',
    y = 'Bike usage',
    title = "Linear Regression"
  )


# Trees ------------------

tree_spec <- decision_tree() |>
  set_engine('rpart') |>
  set_mode('regression')
# Fit the model to the training data
tree_fit <- tree_spec |>
  fit(cnt ~ ., data = df)
tree_fit

# predictions
predictions <- tree_fit |>
  predict(df) |>
  pull(.pred)

metrics <- metric_set(yardstick::rsq)
model_performance <- df |>
  mutate(predictions = predictions) |>
  metrics(truth = cnt, estimate = predictions)
model_performance
tree.rmse <- sqrt(mean((pred - df$cnt)^2))
tree.rmse
# 2632.675

# LASSO ---------------------

X <- df |>
  select(-cnt)

X <- as.matrix(X)
y <- df$cnt
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

lasso.rmse <- sqrt(mean((y_pred - df$cnt)^2))
lasso.rmse
# 2763.379









