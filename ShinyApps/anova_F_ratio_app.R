# app.R
library(shiny)
library(ggplot2)

# Function to generate data based on MSBetween and MSWithin
generate_data <- function(ms_between, ms_within) {
  set.seed(123)  # Ensure reproducibility
  groups <- 3
  n <- 30
  means <- rnorm(groups, mean = 20, sd = ms_between)
  
  data <- data.frame(
    group = rep(paste0("Group ", 1:groups), each = n),
    value = unlist(lapply(means, function(m) rnorm(n, mean = m, sd = ms_within)))
  )
  
  return(data)
}

# Function to perform ANOVA and return MSBetween, MSWithin, F ratio, and p-value
anova_test <- function(data) {
  fit <- aov(value ~ group, data = data)
  anova_result <- summary(fit)
  ms_between <- anova_result[[1]]["Mean Sq"][1, 1]
  ms_within <- anova_result[[1]]["Mean Sq"][2, 1]
  f_ratio <- ms_between / ms_within
  p_value <- anova_result[[1]]["Pr(>F)"][1, 1]
  
  list(ms_between = ms_between, ms_within = ms_within, f_ratio = f_ratio, p_value = p_value)
}

# UI
ui <- fluidPage(
  titlePanel("ANOVA Box Plot with MSBetween and MSWithin Sliders"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("ms_between", "MSBetween:", min = 1, max = 20, value = 5, step = 1),
      sliderInput("ms_within", "MSWithin:", min = 1, max = 20, value = 5, step = 1)
    ),
    
    mainPanel(
      plotOutput("boxplot"),
      htmlOutput("pvalue"),
      htmlOutput("ms_between"),
      htmlOutput("ms_within"),
      htmlOutput("f_ratio")
    )
  )
)

# Server
server <- function(input, output) {
  # Reactive function to generate data
  data <- reactive({
    generate_data(input$ms_between, input$ms_within)
  })
  
  # Reactive function to calculate ANOVA
  anova_results <- reactive({
    anova_test(data())
  })
  
  # Render box plot
  output$boxplot <- renderPlot({
    ggplot(data(), aes(x = group, y = value)) +
      geom_boxplot(fill = "lightblue") +
      theme_minimal() +
      labs(title = "Box Plot for Different Groups", x = "Group", y = "Value")
  })
  
  # Render p-value
  output$pvalue <- renderText({
    results <- anova_results()
    p_value <- results$p_value
    text_color <- ifelse(p_value < 0.05, "red", "black")
    
    if (p_value < 0.001) {
      p_value_text <- "p-value: <0.001"
    } else {
      p_value_text <- sprintf("p-value: %.3f", p_value)
    }
    
    sprintf('<span style="color:%s">%s</span>', text_color, p_value_text)
  })
  
  # Render MSBetween
  output$ms_between <- renderText({
    results <- anova_results()
    sprintf("MSBetween: %.3f", results$ms_between)
  })
  
  # Render MSWithin
  output$ms_within <- renderText({
    results <- anova_results()
    sprintf("MSWithin: %.3f", results$ms_within)
  })
  
  # Render F ratio
  output$f_ratio <- renderText({
    results <- anova_results()
    sprintf("F ratio: MSB/MSW = %.3f/%.3f = %.3f", results$ms_between, results$ms_within, results$f_ratio)
  })
}

# Run the app
shinyApp(ui = ui, server = server)
