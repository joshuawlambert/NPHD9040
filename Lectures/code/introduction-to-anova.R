# R Code for introduction-to-anova.qmd

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Example boxplot in R
data <- data.frame(
  group = rep(c("Placebo", "Behavioral", "Drug"), each = 10),
  stress = c(rnorm(10, 5, 1), rnorm(10, 7, 1), rnorm(10, 6, 1))
)

# Basic boxplot
boxplot(stress ~ group, 
        data = data, 
        main = "Boxplot of Stress Scores",
        xlab = "Group", 
        ylab = "Stress Score",
        col = c("lightblue", "lightgreen", "lightcoral"))

# Add individual points
stripchart(stress ~ group, 
           data = data, 
           vertical = TRUE, 
           method = "jitter",
           add = TRUE, 
           pch = 19, 
           col = "darkgray")

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Fit ANOVA model
model <- aov(stress ~ group, data = data)

# View results
summary(model)

# The output shows:
# - Df: Degrees of freedom
# - Sum Sq: Sum of squares
# - Mean Sq: Mean squares
# - F value: F statistic
# - Pr(>F): P-value

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Extract F-statistic
f_stat <- summary(model)[[1]]$`F value`[1]

# Extract p-value
p_value <- summary(model)[[1]]$`Pr(>F)`[1]

# Print results
cat("F-statistic:", f_stat, "\n")
cat("P-value:", p_value, "\n")

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Check normality of residuals
shapiro.test(residuals(model))

# Q-Q plot for normality
qqnorm(residuals(model))
qqline(residuals(model), col = "red")

# Check homogeneity of variance (requires car package)
library(car)
leveneTest(stress ~ group, data = data)

# Diagnostic plots
par(mfrow = c(2, 2))
plot(model)
par(mfrow = c(1, 1))

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Tukey HSD post-hoc test
tukey_result <- TukeyHSD(model)
print(tukey_result)

# Plot the results
plot(tukey_result)

# The output shows:
# - diff: Difference in means
# - lwr, upr: 95% confidence interval
# - p adj: Adjusted p-value

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Pairwise t-tests with Bonferroni adjustment
pairwise.t.test(data$stress, data$group, p.adjust.method = "bonferroni")

#------------------------------
# ```{r}
#------------------------------

# ============================================
# Complete ANOVA Example
# Research Question: Does treatment type affect pain reduction?
# ============================================

# Step 1: Load required packages
library(car)  # For Levene's test

# Step 2: Create or read data
set.seed(456)
pain_data <- data.frame(
  patient_id = 1:60,
  treatment = rep(c("Standard", "Physical Therapy", "Medication"), each = 20),
  pain_reduction = c(
    rnorm(20, mean = 2.5, sd = 1.2),  # Standard
    rnorm(20, mean = 4.2, sd = 1.3),  # Physical Therapy
    rnorm(20, mean = 3.8, sd = 1.1)   # Medication
  )
)

# Convert treatment to factor
pain_data$treatment <- factor(pain_data$treatment)

# Step 3: Explore the data
cat("=== Data Summary ===\n")
summary(pain_data)

cat("\n=== Sample Sizes ===\n")
table(pain_data$treatment)

cat("\n=== Descriptive Statistics by Group ===\n")
cat("Means:\n")
tapply(pain_data$pain_reduction, pain_data$treatment, mean)

cat("\nStandard Deviations:\n")
tapply(pain_data$pain_reduction, pain_data$treatment, sd)

# Step 4: Visualize the data
par(mfrow = c(1, 2))

# Boxplot
boxplot(pain_reduction ~ treatment,
        data = pain_data,
        main = "Pain Reduction by Treatment",
        xlab = "Treatment",
        ylab = "Pain Reduction (points)",
        col = c("lightblue", "lightgreen", "lightcoral"))

# Add points
stripchart(pain_reduction ~ treatment,
           data = pain_data,
           vertical = TRUE,
           method = "jitter",
           add = TRUE,
           pch = 19,
           col = "darkgray")

# Histogram of all data
hist(pain_data$pain_reduction,
     main = "Distribution of Pain Reduction",
     xlab = "Pain Reduction (points)",
     col = "lightblue",
     border = "white")

par(mfrow = c(1, 1))

# Step 5: Check assumptions
cat("\n=== Assumption Checks ===\n")

# Normality (overall)
cat("\nShapiro-Wilk Test for Normality:\n")
shapiro_test <- shapiro.test(pain_data$pain_reduction)
print(shapiro_test)

# Homogeneity of variance
cat("\nLevene's Test for Homogeneity of Variance:\n")
levene_test <- leveneTest(pain_reduction ~ treatment, data = pain_data)
print(levene_test)

# Step 6: Conduct ANOVA
cat("\n=== ANOVA Results ===\n")
anova_model <- aov(pain_reduction ~ treatment, data = pain_data)
anova_summary <- summary(anova_model)
print(anova_summary)

# Extract key values
f_value <- anova_summary[[1]]$`F value`[1]
p_value <- anova_summary[[1]]$`Pr(>F)`[1]

cat("\nF-statistic:", round(f_value, 3), "\n")
cat("P-value:", format.pval(p_value, digits = 3), "\n")

# Step 7: Check model diagnostics
cat("\n=== Model Diagnostics ===\n")
par(mfrow = c(2, 2))
plot(anova_model)
par(mfrow = c(1, 1))

# Step 8: Post-hoc tests (if ANOVA is significant)
if (p_value < 0.05) {
  cat("\n=== Post-hoc Analysis (Tukey HSD) ===\n")
  tukey_results <- TukeyHSD(anova_model)
  print(tukey_results)
  
  # Plot Tukey results
  plot(tukey_results, las = 1)
  
  cat("\n=== Pairwise Comparisons (Bonferroni) ===\n")
  pairwise_results <- pairwise.t.test(pain_data$pain_reduction, 
                                       pain_data$treatment, 
                                       p.adjust.method = "bonferroni")
  print(pairwise_results)
} else {
  cat("\nANOVA not significant (p >= 0.05). Post-hoc tests not needed.\n")
}

# Step 9: Effect size (eta-squared)
ss_between <- anova_summary[[1]]$`Sum Sq`[1]
ss_total <- sum(anova_summary[[1]]$`Sum Sq`)
eta_squared <- ss_between / ss_total

cat("\n=== Effect Size ===\n")
cat("Eta-squared:", round(eta_squared, 3), "\n")
cat("Interpretation: ", 
    ifelse(eta_squared < 0.01, "negligible",
           ifelse(eta_squared < 0.06, "small",
                  ifelse(eta_squared < 0.14, "medium", "large"))), "\n")

# Step 10: Report results
cat("\n=== Summary for Reporting ===\n")
cat("A one-way ANOVA was conducted to compare pain reduction across three treatment groups.\n")
cat("The ANOVA was", ifelse(p_value < 0.05, "significant", "not significant"), 
    sprintf("F(%d, %d) = %.2f, p %s.\n",
            anova_summary[[1]]$Df[1],
            anova_summary[[1]]$Df[2],
            f_value,
            ifelse(p_value < 0.001, "< .001", paste("=", round(p_value, 3)))))

if (p_value < 0.05) {
  cat("Post-hoc comparisons using Tukey HSD indicated significant differences between groups.\n")
}

cat("\n=== Analysis Complete ===\n")