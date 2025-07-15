library(shiny)

# Define UI ----
ui <- fluidPage(
  
  titlePanel("Post-hoc Analysis: ANOVA"),
  
  sidebarLayout(
    sidebarPanel(
      numericInput("group1_mean", "Mean of Group 1:", value = 5),
      numericInput("group2_mean", "Mean of Group 2:", value = 7),
      numericInput("group3_mean", "Mean of Group 3:", value = 9),
      actionButton("run_anova", "Run ANOVA"),
      actionButton("run_post_hoc", "Run Post-hoc Analysis")
    ),
    
    mainPanel(
      plotOutput("anova_plot"),
      verbatimTextOutput("anova_results"),
      verbatimTextOutput("post_hoc_results")
    )
  )
)

# Define server logic ----
server <- function(input, output) {
  
  # ANOVA
  anova_results <- eventReactive(input$run_anova, {
    data <- data.frame(
      Group = rep(c("Group 1", "Group 2", "Group 3"), each = 10),
      Value = c(rnorm(10, input$group1_mean, 1),
                rnorm(10, input$group2_mean, 1),
                rnorm(10, input$group3_mean, 1))
    )
    anova <- aov(Value ~ Group, data = data)
    summary(anova)
  })
  
  output$anova_results <- renderPrint({
    if (input$run_anova > 0) {
      anova_results()
    }
  })
  
  output$anova_plot <- renderPlot({
    if (input$run_anova > 0) {
      data <- data.frame(
        Group = rep(c("Group 1", "Group 2", "Group 3"), each = 10),
        Value = c(rnorm(10, input$group1_mean, 1),
                  rnorm(10, input$group2_mean, 1),
                  rnorm(10, input$group3_mean, 1))
      )
      boxplot(Value ~ Group, data = data)
    }
  })
  
  # Post-hoc Analysis
  post_hoc_results <- eventReactive(input$run_post_hoc, {
    if (input$run_anova > 0) {
      data <- data.frame(
        Group = rep(c("Group 1", "Group 2", "Group 3"), each = 10),
        Value = c(rnorm(10, input$group1_mean, 1),
                  rnorm(10, input$group2_mean, 1),
                  rnorm(10, input$group3_mean, 1))
      )
      anova <- aov(Value ~ Group, data = data)
      post_hoc <- TukeyHSD(anova)
      post_hoc
    }
  })
  
  output$post_hoc_results <- renderPrint({
    if (input$run_post_hoc > 0) {
      post_hoc_results()
    }
  })
}

# Run the application
shinyApp(ui = ui, server = server)
