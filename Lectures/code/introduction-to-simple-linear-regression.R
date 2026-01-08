# R Code for introduction-to-simple-linear-regression.qmd

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Scatter plot in R
set.seed(123)
x <- rnorm(100)
y <- 3 * x + rnorm(100)

plot(x, y, main = "Scatter Plot of Predictor vs. Outcome", xlab = "Predictor (x)", ylab = "Outcome (y)", col = "blue")

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Residual plots and Q-Q plot in R
fit <- lm(y ~ x)

# Residual vs. Fitted plot
plot(fit, which = 1, main = "Residuals vs. Fitted")

# Q-Q plot
plot(fit, which = 2, main = "Q-Q Plot")

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Example in R
# Simulated data
set.seed(123)
BMI <- rnorm(100, mean = 25, sd = 3)
BP <- 2 * BMI + rnorm(100, sd = 5)

# Simple Linear Regression
fit1 <- lm(BP ~ BMI)
summary(fit1)

# Plot
plot(BMI, BP, main = "BMI vs. Blood Pressure", xlab = "BMI", ylab = "Blood Pressure")
abline(fit1, col = "red")