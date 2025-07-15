# Load required libraries
library(shiny)
library(ggplot2)
library(tidyr)
library(dplyr)
library(car)
library(readxl)

# Define UI
ui <- fluidPage(
  titlePanel("BOSAS Dataset Analysis"),
  
  sidebarLayout(
    sidebarPanel(
      h4("Select Analysis Options"),
      br(),
      actionButton("run_analysis", "Run Analysis")
    ),
    
    mainPanel(
      h4("BOSAS Dataset"),
      br(),
      tableOutput("data_summary"),
      br(),
      plotOutput("boxplot")
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  # Load dataset
  dataset <- read_excel("/home/josh/JoshResearch/NPHD9040_Course_Website/ShinyApps/RM_ANOVA_EX1.xlsx")
  
  # Display dataset
  output$data_summary <- renderDataTable({
    summary_stats <- as.matrix(summary(dataset))
    summary_stats
  })
  
  # Plot boxplot
  output$boxplot <- renderPlot({
    ggplot(dataset, aes(x = factor(Time_Point), y = BOSAS_Score)) +
      geom_boxplot() +
      labs(x = "Time Point", y = "BOSAS Score") +
      ggtitle("BOSAS Score Distribution Over Time")
  })
  
  # Run repeated measures ANOVA when the action button is clicked
  observeEvent(input$run_analysis, {
    # Reshape dataset for repeated measures ANOVA
    dataset_long <- dataset %>%
      pivot_longer(cols = starts_with("Time_Point"), names_to = "Time_Point", values_to = "BOSAS_Score")
    
    # Run repeated measures ANOVA
    anova_result <- Anova(aov(BOSAS_Score ~ Time_Point + Error(Nurse_ID/Time_Point), data = dataset_long), type = "III")
    
    # Print ANOVA result
    cat("\nRepeated Measures ANOVA:\n")
    print(anova_result)
  })
}

# Run the application
shinyApp(ui = ui, server = server)
