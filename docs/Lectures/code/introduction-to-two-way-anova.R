# R Code for introduction-to-two-way-anova.qmd

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Example in R
# Simulated data
set.seed(123)
data <- data.frame(
  Dosage = factor(rep(c("Low", "Medium", "High"), each = 30)),
  Diet = factor(rep(c("Control", "Low-Fat", "High-Fat"), times = 30)),
  BP = rnorm(90, mean = rep(c(120, 115, 130), each = 30), sd = 10)
)

# Two-Way ANOVA
model <- aov(BP ~ Dosage * Diet, data = data)
summary(model)

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Example in R
# Simulated data
set.seed(456)
data2 <- data.frame(
  Intervention = factor(rep(c("Control", "Intensive"), each = 50)),
  Gender = factor(rep(c("Male", "Female"), times = 50)),
  RecoveryTime = rnorm(100, mean = rep(c(14, 12), each = 50), sd = 3)
)

# Two-Way ANOVA
model2 <- aov(RecoveryTime ~ Intervention * Gender, data = data2)
summary(model2)