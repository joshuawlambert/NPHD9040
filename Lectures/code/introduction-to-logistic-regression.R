# R Code for introduction-to-logistic-regression.qmd

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Logistic Regression in R
        data <- read.csv("health_data.csv")
        model <- glm(Diabetes ~ Age + BMI, data = data, family = "binomial")
        summary(model)

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Logistic Regression in R
        data <- read.csv("heart_data.csv")
        model <- glm(HeartDisease ~ Age + Cholesterol + Smoking, data = data, family = "binomial")
        summary(model)