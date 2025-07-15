# Load required libraries
library(shiny)
library(ggplot2) # For plotting
library(dplyr)   # For data manipulation

# Define UI
ui <- fluidPage(
  titlePanel("ANOVA Assumptions Visualization"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("num_groups", "Number of Groups:", min = 2, max = 5, value = 3),
      numericInput("n", "Sample Size per Group:", value = 50, min = 10, max = 1000),
      sliderInput("msb", "Between-group Mean Square:", min = 0, max = 100, value = 10),
      sliderInput("msw", "Within-group Mean Square:", min = 0, max = 100, value = 10),
      actionButton("generate_analyze_button", "Generate Random Data and GO!")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Summary Statistics", h3("
With mean, median, and variance alone, you can roughly assess normality by comparing mean and median proximity and evaluate homogeneity of variances by comparing variances across groups. However, more robust methods such as formal tests and graphical analysis are typically needed for accurate assessment of ANOVA assumptions."), tableOutput("summary_table")),
        tabPanel("Histogram", 
                 h3("Histograms of the dependent variable by group in an ANOVA (Analysis of Variance) analysis can provide valuable insights into the assumptions of ANOVA, particularly regarding the assumption of homogeneity of variances and normality."),
                 tabsetPanel(
                   tabPanel("Group 1", h3("Histogram for Group 1"), plotOutput("histogram_group1")),
                   tabPanel("Group 2", h3("Histogram for Group 2"), plotOutput("histogram_group2")),
                   tabPanel("Group 3", h3("Histogram for Group 3"), plotOutput("histogram_group3")),
                   tabPanel("Group 4", h3("Histogram for Group 4"), plotOutput("histogram_group4")),
                   tabPanel("Group 5", h3("Histogram for Group 5"), plotOutput("histogram_group5"))
                 )
        ),
        tabPanel("QQ Plot", h3("
A QQ plot (Quantile-Quantile plot) of the dependent variable by group in an ANOVA analysis provides a visual assessment of the normality assumption. It compares the distribution of the observed data within each group to a theoretical normal distribution."), plotOutput("qqplot")),
        tabPanel("Box Plot", h3("
A box plot of the dependent variable by group visually displays the central tendency, variability, and presence of outliers within each group. It allows for quick comparisons of these characteristics across different groups, aiding in the assessment of assumptions such as homogeneity of variances and providing insights into group differences in the distribution of the dependent variable in ANOVA analysis. This graphical tool facilitates the identification of potential patterns or discrepancies in the data, guiding further analysis and interpretation of ANOVA results."), plotOutput("boxplot")),
        tabPanel("Levene's Plot", 
                 h3("
Levene's plot for homogeneity of variances by group in ANOVA provides a visual assessment of whether the variances of the dependent variable are approximately equal across different groups or levels of the independent variable."),
                 plotOutput("levene_plot")
        )
      )
    )
  )
)

# Define server logic
server <- function(input, output) {
  data <- reactiveVal(NULL)
  
  observeEvent(input$generate_analyze_button, {
    # Generate random data
    num_groups <- input$num_groups
    group_names <- paste0("Group", 1:num_groups)
    group_data <- lapply(1:num_groups, function(i) {
      data.frame(group = group_names[i], value = rnorm(input$n, mean = 50, sd = sqrt(input$msw)))
    })
    all_data <- bind_rows(group_data)
    data(all_data)
    
    # Update between-group mean square (MSB) and within-group mean square (MSW)
    msb <- input$msb
    msw <- input$msw
    
    # Adjust data based on MSB
    for (i in 1:num_groups) {
      all_data$value[all_data$group == group_names[i]] <- 
        all_data$value[all_data$group == group_names[i]] + (msb * (i - 1))
    }
    
    # Perform ANOVA assumptions tests
   
    # Summary statistics
    summary_stats <- all_data %>%
      group_by(group) %>%
      summarise(mean = mean(value), median = median(value), variance = var(value))
    
    output$summary_table <- renderTable({
      summary_stats
    })
    
    # Example visualizations
    output$histogram_group1 <- renderPlot({
      ggplot(data = filter(all_data, group == "Group1"), aes(x = value)) +
        geom_histogram(binwidth = 1, color = "black") +
        labs(title = "Histogram for Group 1", x = "Dependent Variable", y = "Frequency")
    })
    
    output$histogram_group2 <- renderPlot({
      ggplot(data = filter(all_data, group == "Group2"), aes(x = value)) +
        geom_histogram(binwidth = 1, color = "black") +
        labs(title = "Histogram for Group 2", x = "Dependent Variable", y = "Frequency")
    })
    
    output$histogram_group3 <- renderPlot({
      ggplot(data = filter(all_data, group == "Group3"), aes(x = value)) +
        geom_histogram(binwidth = 1, color = "black") +
        labs(title = "Histogram for Group 3", x = "Dependent Variable", y = "Frequency")
    })
    
    output$histogram_group4 <- renderPlot({
      ggplot(data = filter(all_data, group == "Group4"), aes(x = value)) +
        geom_histogram(binwidth = 1, color = "black") +
        labs(title = "Histogram for Group 4", x = "Dependent Variable", y = "Frequency")
    })
    
    output$histogram_group5 <- renderPlot({
      ggplot(data = filter(all_data, group == "Group5"), aes(x = value)) +
        geom_histogram(binwidth = 1, color = "black") +
        labs(title = "Histogram for Group 5", x = "Dependent Variable", y = "Frequency")
    })
    
    output$qqplot <- renderPlot({
      ggplot(data = all_data, aes(sample = value)) +
        geom_qq() +
        geom_qq_line() +
        facet_wrap(~group) +
        labs(title = "QQ Plot of Dependent Variable")
    })
    
    output$boxplot <- renderPlot({
      # Plot box plot
      ggplot(all_data, aes(x = group, y = value, fill = group)) +
        geom_boxplot() +
        labs(title = "Box Plot of Dependent Variable", x = "Group", y = "Value")
    })
    
    output$levene_plot <- renderPlot({
      # Plot Levene's test
      group_variances <- tapply(all_data$value, all_data$group, var)
      
      # Create a bar plot to visualize group variances
      barplot(group_variances, 
              main = "Variances of Groups",
              xlab = "Group", ylab = "Variance",
              names.arg = unique(all_data$group),
              col = "skyblue",
              ylim = c(0, max(group_variances) * 1.2))
    })
    
  })
}

# Run the application
shinyApp(ui = ui, server = server)
