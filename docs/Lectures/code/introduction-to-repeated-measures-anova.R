# R Code for introduction-to-repeated-measures-anova.qmd

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Example in R
# Simulated data
set.seed(123)
data <- data.frame(
  Subject = rep(1:20, each = 3),
  Time = factor(rep(c("Baseline", "Week1", "Week3"), times = 20)),
  BP = rnorm(60, mean = rep(c(120, 115, 110), each = 20), sd = 10)
)

# Repeated Measures ANOVA
install.packages("ez")
library(ez)
anova_results <- ezANOVA(
  data = data,
  dv = BP,
  wid = Subject,
  within = Time
)
print(anova_results)

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Example in R
# Simulated data
set.seed(456)
data2 <- data.frame(
  Subject = rep(1:15, each = 4),
  Session = factor(rep(c("Session1", "Session2", "Session3", "Session4"), times = 15)),
  Score = rnorm(60, mean = rep(c(80, 85, 90, 95), each = 15), sd = 5)
)

# Repeated Measures ANOVA
library(ez)
anova_results2 <- ezANOVA(
  data = data2,
  dv = Score,
  wid = Subject,
  within = Session
)
print(anova_results2)