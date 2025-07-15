# Load necessary libraries
library(shiny)
library(ggplot2)
library(dplyr)
library(emmeans)
library(car)

# Generate synthetic data for two-way ANOVA visualization
generate_data <- function(msa, msb, msab, n = 10, sigma = 1) {
  factor_A <- gl(3, n, labels = c("A1", "A2", "A3"))
  factor_B <- gl(3, 1, 3 * n, labels = c("B1", "B2", "B3"))
  
  # Means based on Mean Squares (MSA, MSB, MSAB)
  mean_A <- c(0, sqrt(msa), 2 * sqrt(msa))
  mean_B <- c(0, sqrt(msb), 2 * sqrt(msb))
  mean_AB <- matrix(c(
    0, sqrt(msab), 2 * sqrt(msab),
    sqrt(msab), 2 * sqrt(msab), 0,
    2 * sqrt(msab), 0, sqrt(msab)
  ), nrow = 3, byrow = TRUE)
  
  means <- mean_A[as.numeric(factor_A)] + mean_B[as.numeric(factor_B)] +
    sapply(seq_len(length(factor_A)), function(i) mean_AB[as.numeric(factor_A[i]), as.numeric(factor_B[i])])
  
  response <- means + rnorm(length(means), sd = sigma)
  
  data.frame(factor_A, factor_B, response)
}

# Shiny App UI
ui <- fluidPage(
  titlePanel("Two-Way ANOVA Visualization with Tukey Test"),
  sidebarLayout(
    sidebarPanel(
      numericInput("msa", "MSA (Mean Square Factor A)", value = 5, min = 0),
      numericInput("msb", "MSB (Mean Square Factor B)", value = 5, min = 0),
      numericInput("msab", "MSAB (Mean Square Interaction)", value = 2, min = 0),
      numericInput("sigma", "Residual Standard Deviation", value = 1, min = 0),
      numericInput("n", "Sample Size per Group", value = 10, min = 1),
      actionButton("generate", "Generate Data and Analyze"),
      downloadButton("downloadData", "Download Current Dataset")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Plots", plotOutput("boxplotA")),
        tabPanel("ANOVA Results", verbatimTextOutput("anovaResults")),
        tabPanel("Tukey Test Results", verbatimTextOutput("tukeyResults")),
        tabPanel("QQ Plot", plotOutput("qqplot")),
        tabPanel("Levene's Plot", plotOutput("levenesPlot"))
      )
    )
  )
)

# Shiny App Server
server <- function(input, output) {
  data <- reactiveVal()
  
  observeEvent(input$generate, {
    data(generate_data(input$msa, input$msb, input$msab, n = input$n, sigma = input$sigma))
  })
  
  output$boxplotA <- renderPlot({
    if (is.null(data())) return(NULL)
    ggplot(data(), aes(x = factor_A, y = response, fill = factor_B)) +
      geom_boxplot() +
      theme_minimal() +
      labs(title = "Boxplot of Factor A grouped by Factor B", x = "Factor A", y = "Response")
  })
  
  output$anovaResults <- renderPrint({
    if (is.null(data())) return(NULL)
    model <- aov(response ~ factor_A * factor_B, data = data())
    summary(model)
  })
  
  output$tukeyResults <- renderPrint({
    if (is.null(data())) return(NULL)
    model <- aov(response ~ factor_A * factor_B, data = data())
    tukey <- TukeyHSD(model)
    tukey
  })
  
  output$qqplot <- renderPlot({
    if (is.null(data())) return(NULL)
    model <- aov(response ~ factor_A * factor_B, data = data())
    qqnorm(resid(model))
    qqline(resid(model))
  })
  
  output$levenesPlot <- renderPlot({
    if (is.null(data())) return(NULL)
    
    # Absolute deviations from medians
    data_lev <- data() %>%
      group_by(factor_A, factor_B) %>%
      mutate(dev_median = abs(response - median(response)))
    
    ggplot(data_lev, aes(x = interaction(factor_A, factor_B), y = dev_median, fill = interaction(factor_A, factor_B))) +
      geom_boxplot() +
      theme_minimal() +
      labs(title = "Levene's Plot (Absolute Deviations from Medians)",
           x = "Groups (Factor A and Factor B)", y = "Absolute Deviations") +
      theme(legend.position = "none")
  })
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("two_way_anova_data-", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(data(), file, row.names = FALSE)
    }
  )
}

# Run the Shiny App
shinyApp(ui, server)
