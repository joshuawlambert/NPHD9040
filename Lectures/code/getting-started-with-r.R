# R Code for getting-started-with-r.qmd

#------------------------------
# ```{r}
#------------------------------

# Assign the value 5 to an object called 'x'
x <- 5

# View the value of x
x

# You can also use = for assignment, but <- is preferred in R
y <- 10
y

#------------------------------
# ```{r}
#------------------------------

# Numeric (numbers)
age <- 45
weight <- 68.5

# Character (text - always in quotes)
name <- "Patient A"
diagnosis <- "Hypertension"

# Logical (TRUE or FALSE)
is_smoker <- TRUE
has_diabetes <- FALSE

# Check the type of an object
class(age)
class(name)
class(is_smoker)

#------------------------------
# ```{r}
#------------------------------

# Numeric vector
ages <- c(25, 34, 45, 56, 67)
ages

# Character vector
treatments <- c("Placebo", "Drug A", "Drug B", "Placebo", "Drug A")
treatments

# Access individual elements using brackets []
ages[1]  # First element
ages[3]  # Third element

# Access multiple elements
ages[c(1, 3, 5)]  # First, third, and fifth elements

#------------------------------
# ```{r}
#------------------------------

# Create a simple data frame
patient_data <- data.frame(
  patient_id = c(1, 2, 3, 4, 5),
  age = c(25, 34, 45, 56, 67),
  treatment = c("Placebo", "Drug A", "Drug B", "Placebo", "Drug A"),
  outcome = c(5.2, 6.8, 7.1, 5.5, 6.9)
)

# View the data frame
patient_data

# View structure of the data frame
str(patient_data)

# View first few rows
head(patient_data)

# Access a column using $
patient_data$age

# Access a column using brackets
patient_data[, "treatment"]

# Access a specific cell [row, column]
patient_data[2, 3]  # Row 2, Column 3

#------------------------------
# ```{r}
#------------------------------

# Calculate mean (average)
mean(ages)

# Calculate standard deviation
sd(ages)

# Calculate median
median(ages)

# Summary statistics
summary(ages)

# Count number of elements
length(ages)

# Create a table of frequencies
table(treatments)

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Check current working directory
getwd()

# Set working directory (use your own path)
setwd("C:/Users/YourName/Documents/R_Projects")

# Or use Session → Set Working Directory → Choose Directory in RStudio

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Read a CSV file by providing the path
my_data <- read.csv("data/patient_data.csv")

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# This will open a window for you to select the file manually
my_data <- read.csv(file.choose())

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# View the first few rows
head(my_data)

# View the structure (variable names and types)
str(my_data)

# View the entire dataset in a spreadsheet-like viewer
View(my_data)

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Install the package (only needed once)
install.packages("readxl")

# Load the package (needed each session)
library(readxl)

# Read an Excel file
my_data <- read_excel("data_file.xlsx")

# Read a specific sheet
my_data <- read_excel("data_file.xlsx", sheet = "Sheet1")

#------------------------------
# ```{r}
#------------------------------

# Create example data
patient_data <- data.frame(
  patient_id = 1:10,
  age = c(25, 34, 45, 56, 67, 23, 45, 56, 78, 34),
  treatment = rep(c("Placebo", "Drug A"), 5),
  outcome = c(5.2, 6.8, 7.1, 5.5, 6.9, 5.0, 7.2, 6.5, 7.8, 6.2)
)

# Select specific columns
patient_data[, c("patient_id", "age")]

# Select rows where age > 40
patient_data[patient_data$age > 40, ]

# Using subset() function (easier to read)
subset(patient_data, age > 40)

# Select specific columns for subset
subset(patient_data, age > 40, select = c(patient_id, age, outcome))

#------------------------------
# ```{r}
#------------------------------

# Add a new column
patient_data$age_group <- ifelse(patient_data$age >= 50, "Older", "Younger")

# View the updated data
patient_data

# Create a new variable based on calculations
patient_data$outcome_doubled <- patient_data$outcome * 2

patient_data

#------------------------------
# ```{r}
#------------------------------

# Log transformation
patient_data$log_outcome <- log(patient_data$outcome)

# Standardization (z-scores)
patient_data$outcome_z <- scale(patient_data$outcome)

# View results
head(patient_data)

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Install a package (only needed once)
install.packages("ggplot2")

# Install multiple packages at once
install.packages(c("ggplot2", "dplyr", "car"))

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Load a package (needed each time you start R)
library(ggplot2)

# Alternative way to load
require(ggplot2)

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Get help on a function
?mean
help(mean)

# Search for help on a topic
??regression

# Get examples of how to use a function
example(mean)

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Error: object not found
print(my_variable)
# Fix: Make sure you've created the object and spelled it correctly

# Error: could not find function
myfunction()
# Fix: Check spelling, or load the package that contains the function

# Error: unexpected symbol
x < - 5  # Space in assignment operator
# Fix: Remove the space: x <- 5

#------------------------------
# ```{r}
#------------------------------

# Calculate the mean age of patients
mean_age <- mean(patient_data$age)

# This is a comment - R ignores everything after #

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Good
patient_age <- 45
treatment_group <- "Drug A"

# Not as good
x <- 45
tg <- "Drug A"

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# ============================================
# Project: Blood Pressure Study
# Author: Your Name
# Date: 2026-01-05
# ============================================

# Load packages
library(ggplot2)
library(car)

# Read data
bp_data <- read.csv("blood_pressure.csv")

# Data cleaning
# ... your code ...

# Analysis
# ... your code ...

# Visualization
# ... your code ...

#------------------------------
# ```{r, eval=FALSE}
#------------------------------

# Save data frame as CSV
write.csv(patient_data, "cleaned_data.csv", row.names = FALSE)

# Save R objects
save(patient_data, file = "my_data.RData")

# Load saved R objects
load("my_data.RData")

#------------------------------
# ```{r}
#------------------------------

# ============================================
# Example: Analyzing Patient Recovery Times
# ============================================

# Step 1: Create sample data (normally you'd read this from a file)
recovery_data <- data.frame(
  patient_id = 1:30,
  age = c(45, 52, 38, 61, 49, 55, 42, 58, 47, 53,
          39, 44, 56, 50, 43, 59, 48, 51, 46, 54,
          41, 57, 62, 40, 60, 37, 63, 36, 64, 35),
  treatment = rep(c("Standard", "Enhanced", "Intensive"), each = 10),
  recovery_days = c(12, 15, 10, 18, 14, 16, 11, 17, 13, 15,
                    9, 11, 8, 12, 10, 13, 9, 11, 10, 12,
                    7, 9, 6, 8, 7, 9, 6, 8, 7, 8)
)

# Step 2: Examine the data
print("First few rows:")
head(recovery_data)

print("\nData structure:")
str(recovery_data)

print("\nSummary statistics:")
summary(recovery_data)

# Step 3: Basic descriptive statistics by group
print("\nMean recovery days by treatment:")
tapply(recovery_data$recovery_days, recovery_data$treatment, mean)

print("\nStandard deviation by treatment:")
tapply(recovery_data$recovery_days, recovery_data$treatment, sd)

# Step 4: Create a new variable (age group)
recovery_data$age_group <- ifelse(recovery_data$age >= 50, "50+", "Under 50")

# Step 5: Create a simple visualization
boxplot(recovery_days ~ treatment, 
        data = recovery_data,
        main = "Recovery Days by Treatment",
        xlab = "Treatment Type",
        ylab = "Recovery Days",
        col = c("lightblue", "lightgreen", "lightcoral"))

# For more advanced visualizations, see the [Graphing Your Data](graphing-your-data.qmd) lecture.

# Step 6: Basic statistical test (we'll learn more about this later)
# ANOVA to test if recovery days differ by treatment
# Learn more in the [Introduction to ANOVA](introduction-to-anova.qmd) lecture.
anova_result <- aov(recovery_days ~ treatment, data = recovery_data)
print("\nANOVA Results:")
summary(anova_result)

# Step 7: Save the cleaned data (if this were a real analysis)
# write.csv(recovery_data, "recovery_data_cleaned.csv", row.names = FALSE)