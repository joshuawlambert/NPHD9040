# R Code for preliminaries.qmd

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Convert to factor
pain_level <- factor(c("low", "medium", "high", "low", "high"))

# Ordered factor (for ordinal data)
pain_level <- factor(c("low", "medium", "high", "low", "high"),
                     levels = c("low", "medium", "high"),
                     ordered = TRUE)

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Install the package (only once)
install.packages("pwr")

# Load the package
library(pwr)

# Example: Power analysis for t-test
# What sample size do we need to detect a medium effect (d=0.5)
# with 80% power at alpha=0.05?
pwr.t.test(d = 0.5,           # Effect size (Cohen's d)
           sig.level = 0.05,   # Alpha
           power = 0.80,       # Desired power
           type = "two.sample")

# Example: What power do we have with n=30 per group?
pwr.t.test(n = 30,
           d = 0.5,
           sig.level = 0.05,
           type = "two.sample")

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Check your current working directory
getwd()

# Set working directory to where your data is stored
setwd("C:/Users/YourName/Documents/NPHD9040")

# Or use RStudio: Session → Set Working Directory → Choose Directory

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Read CSV file
my_data <- read.csv("patient_data.csv")

# Select file interactively
# my_data <- read.csv(file.choose())

# Read CSV with specific options
my_data <- read.csv("patient_data.csv",
                    header = TRUE,        # First row contains column names
                    stringsAsFactors = FALSE)  # Don't auto-convert to factors

# For Excel files, use readxl package
library(readxl)
my_data <- read_excel("patient_data.xlsx")

# View the data
View(my_data)  # Opens in spreadsheet viewer
head(my_data)  # First 6 rows
tail(my_data)  # Last 6 rows

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Summary statistics for all variables
summary(my_data)

# Mean, median, standard deviation for a specific variable
mean(my_data$age)
median(my_data$age)
sd(my_data$age)

# Remove missing values with na.rm = TRUE
mean(my_data$age, na.rm = TRUE)

# Frequency table for categorical variables
table(my_data$treatment_group)

# Cross-tabulation
table(my_data$treatment_group, my_data$outcome_category)

# Proportions
prop.table(table(my_data$treatment_group))

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Check for missing values
sum(is.na(my_data))  # Total missing values

# Missing values per variable
colSums(is.na(my_data))

# Identify rows with any missing values
my_data[!complete.cases(my_data), ]

# Remove rows with missing values (use with caution!)
my_data_complete <- na.omit(my_data)

#------------------------------
# ```{r}
#------------------------------

# ============================================
# Exploratory Data Analysis Example
# Research Question: Do pain scores differ by treatment group?
# ============================================

# Step 1: Create sample data (normally you'd read from a file)
set.seed(123)  # For reproducibility
pain_study <- data.frame(
  patient_id = 1:60,
  age = round(rnorm(60, mean = 55, sd = 12)),
  sex = sample(c("Male", "Female"), 60, replace = TRUE),
  treatment = rep(c("Standard", "Intervention A", "Intervention B"), each = 20),
  baseline_pain = round(rnorm(60, mean = 7, sd = 1.5), 1),
  followup_pain = c(
    round(rnorm(20, mean = 6.5, sd = 1.5), 1),  # Standard
    round(rnorm(20, mean = 4.5, sd = 1.5), 1),  # Intervention A
    round(rnorm(20, mean = 3.8, sd = 1.5), 1)   # Intervention B
  )
)

# Step 2: Examine the data structure
cat("Data Structure:\n")
str(pain_study)

cat("\n\nFirst few rows:\n")
head(pain_study)

# Step 3: Check for missing data
cat("\n\nMissing values per variable:\n")
colSums(is.na(pain_study))

# Step 4: Convert categorical variables to factors
pain_study$sex <- factor(pain_study$sex)
pain_study$treatment <- factor(pain_study$treatment)

# Step 5: Descriptive statistics - Overall
cat("\n\nOverall Summary Statistics:\n")
summary(pain_study)

# Step 6: Descriptive statistics by group
cat("\n\nMean Follow-up Pain by Treatment:\n")
tapply(pain_study$followup_pain, pain_study$treatment, mean)

cat("\n\nSD of Follow-up Pain by Treatment:\n")
tapply(pain_study$followup_pain, pain_study$treatment, sd)

# Step 7: Create pain reduction variable
pain_study$pain_reduction <- pain_study$baseline_pain - pain_study$followup_pain

cat("\n\nMean Pain Reduction by Treatment:\n")
tapply(pain_study$pain_reduction, pain_study$treatment, mean)

# Step 8: Frequency tables
cat("\n\nSample Size by Treatment:\n")
table(pain_study$treatment)

cat("\n\nSample Size by Treatment and Sex:\n")
table(pain_study$treatment, pain_study$sex)

# Step 9: Visualize the data
par(mfrow = c(2, 2))  # 2x2 grid of plots

# Histogram of age
hist(pain_study$age, 
     main = "Distribution of Age",
     xlab = "Age (years)",
     col = "lightblue",
     border = "white")

# Boxplot of follow-up pain by treatment
boxplot(followup_pain ~ treatment,
        data = pain_study,
        main = "Follow-up Pain by Treatment",
        xlab = "Treatment Group",
        ylab = "Pain Score",
        col = c("lightcoral", "lightgreen", "lightblue"))

# Boxplot of pain reduction by treatment
boxplot(pain_reduction ~ treatment,
        data = pain_study,
        main = "Pain Reduction by Treatment",
        xlab = "Treatment Group",
        ylab = "Pain Reduction",
        col = c("lightcoral", "lightgreen", "lightblue"))

# Scatter plot of baseline vs follow-up pain
plot(pain_study$baseline_pain, pain_study$followup_pain,
     main = "Baseline vs Follow-up Pain",
     xlab = "Baseline Pain",
     ylab = "Follow-up Pain",
     pch = 19,
     col = as.numeric(pain_study$treatment))
legend("topright", 
       legend = levels(pain_study$treatment),
       col = 1:3,
       pch = 19)

# Reset plot layout
par(mfrow = c(1, 1))

# Step 10: Check assumptions visually
# Normality of pain reduction
cat("\n\nShapiro-Wilk Test for Normality (Pain Reduction):\n")
shapiro.test(pain_study$pain_reduction)

# Q-Q plot for normality
qqnorm(pain_study$pain_reduction)
qqline(pain_study$pain_reduction, col = "red")

# Step 11: Save cleaned data (optional)
# write.csv(pain_study, "pain_study_cleaned.csv", row.names = FALSE)

cat("\n\n=== Exploratory Analysis Complete ===\n")
cat("Next steps: Proceed with formal statistical testing in the [Introduction to ANOVA](introduction-to-anova.qmd) lecture.\n")