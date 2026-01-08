# R Code for introduction-to-ancova.qmd

#------------------------------
# ```{r, echo=FALSE, message=FALSE}
#------------------------------

    # Example visualization in R
        library(ggplot2)
        set.seed(123)
        data <- data.frame(
          group = rep(c("Placebo", "Behavioral", "Drug"), each = 10),
          pre_stress = rnorm(30, 5, 1),
          post_stress = c(rnorm(10, 5, 1), rnorm(10, 7, 1), rnorm(10, 6, 1))
        )

        # Interaction plot
        ggplot(data, aes(x = pre_stress, y = post_stress, color = group)) +
          geom_point() +
          geom_smooth(method = "lm", se = FALSE) +
          labs(title = "Interaction Plot", x = "Pre-Stress Score", y = "Post-Stress Score")
      

#------------------------------
# ```{r, echo=FALSE, message=FALSE}
#------------------------------

# Example visualization in R with same slopes
library(ggplot2)
set.seed(123)

# Generate pre_stress values
pre_stress <- rnorm(30, 5, 1)

# Common linear equation for all groups
common_slope <- 0.8  # Choose a common slope
intercept <- 1       # Choose a common intercept

# Calculate post_stress using the common linear equation
post_stress <- pre_stress * common_slope + intercept + rnorm(30, 0, 1)

# Create the data frame
data <- data.frame(
  group = rep(c("Placebo", "Behavioral", "Drug"), each = 10),
  pre_stress = pre_stress,
  post_stress = post_stress
)

# Interaction plot with same slopes
ggplot(data, aes(x = pre_stress, y = post_stress, color = group)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "Interaction Plot with Same Slopes", x = "Pre-Stress Score", y = "Post-Stress Score")


#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Example visualization in R
        library(ggplot2)

        data <- data.frame(
          group = rep(c("Placebo", "Behavioral", "Drug"), each = 10),
          pre_stress = rnorm(30, 5, 1),
          post_stress = c(rnorm(10, 5, 1), rnorm(10, 7, 1), rnorm(10, 6, 1))
        )

        # Interaction plot
        ggplot(data, aes(x = pre_stress, y = post_stress, color = group)) +
          geom_point() +
          geom_smooth(method = "lm", se = FALSE) +
          labs(title = "Interaction Plot", x = "Pre-Stress Score", y = "Post-Stress Score")

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Adjusted means in R
        library(car)
        model <- lm(post_stress ~ group + pre_stress, data = data)
        Anova(model, type = 3)
        lsmeans <- emmeans::emmeans(model, "group")
        print(lsmeans)

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Testing main effects and interaction in R
        model <- lm(post_stress ~ group * pre_stress, data = data)
        Anova(model, type = 3)

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Effect sizes and significance in R
        model <- lm(post_stress ~ group + pre_stress, data = data)
        Anova(model, type = 3)

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Example ANCOVA in R
        model <- lm(post_stress ~ group + pre_stress, data = data)
        summary(model)
        Anova(model, type = 3)