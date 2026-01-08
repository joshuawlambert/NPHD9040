# R Code for introduction-to-multiple-linear-regression.qmd

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Example in R
# Simulated data
set.seed(456)
data <- data.frame(
  Age = rnorm(100, mean = 50, sd = 10),
  Medication_Adherence = rnorm(100, mean = 75, sd = 10),
  Physiotherapy_Sessions = rnorm(100, mean = 20, sd = 5),
  Recovery_Time = rnorm(100, mean = 30, sd = 5)
)

# Multiple Linear Regression
fit <- lm(Recovery_Time ~ Age + Medication_Adherence + Physiotherapy_Sessions, data = data)
summary(fit)

# Residual Plots
par(mfrow = c(2, 2))
plot(fit)

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Example in R
# Simulated data
set.seed(789)
data2 <- data.frame(
  Exercise_Frequency = rnorm(100, mean = 3, sd = 1),
  Diet_Quality = rnorm(100, mean = 7, sd = 2),
  Sleep_Duration = rnorm(100, mean = 8, sd = 1),
  Heart_Health_Index = rnorm(100, mean = 75, sd = 10)
)

# Multiple Linear Regression
fit2 <- lm(Heart_Health_Index ~ Exercise_Frequency + Diet_Quality + Sleep_Duration, data = data2)
summary(fit2)

# Residual Plots
par(mfrow = c(2, 2))
plot(fit2)