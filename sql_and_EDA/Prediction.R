# Libraries
library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(caret)
library(e1071)

# Load datasets
financial_data <- read.csv("financial_data_cleaned.csv")
project_management_data <- read.csv("project_management_data_cleaned.csv")
risk_management_data <- read.csv("risk_and_contingency_management_cleaned.csv")
action_decision_data <- read.csv("action_and_decision_tracking_cleaned.csv")

# UI part of the dashboard
ui <- dashboardPage(
  dashboardHeader(title = "Traxidy Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Financial Overview", tabName = "financial_overview", icon = icon("dollar-sign")),
      menuItem("Project Management", tabName = "project_management", icon = icon("tasks")),
      menuItem("Risk Management", tabName = "risk_management", icon = icon("exclamation-triangle")),
      menuItem("Action and Decision Tracking", tabName = "action_decision", icon = icon("clipboard-check"))
    )
  ),
  
  dashboardBody(
    tabItems(
      # Financial Overview Tab
      tabItem(tabName = "financial_overview",
              h2("Financial Overview"),
              fluidRow(
                column(6, plotOutput("financialPlot")),  # Financial data plot
                column(6, plotOutput("financialPredictionPlot"))  # Financial Prediction plot
              ),
              tableOutput("financialTable")  # Financial data table
      ),
      
      # Project Management Tab with GYR Constraint Distribution
      tabItem(tabName = "project_management",
              h2("Project Management Overview"),
              selectInput("project", "Select Project Name", choices = unique(project_management_data$project_name)),
              fluidRow(
                column(6, plotOutput("gyrPieChart")),  # GYR Constraint Pie Chart
                column(6, plotOutput("projectPredictionPlot"))  # Project Prediction plot
              ),
              tableOutput("gyrTable")  # GYR Table for mapping abbreviations
      ),
      
      # Risk Management Tab
      tabItem(tabName = "risk_management",
              h2("Risk and Contingency Management"),
              fluidRow(
                column(6, plotOutput("riskPlot")),  # Risk management plot
                column(6, plotOutput("riskPredictionPlot"))  # Risk Prediction plot
              ),
              tableOutput("riskManagementTable")  # Risk management data table
      ),
      
      # Action and Decision Tracking Tab
      tabItem(tabName = "action_decision",
              h2("Action and Decision Tracking"),
              plotOutput("actionDecisionPlot"),  # Action and Decision plot
              tableOutput("actionDecisionTable")  # Action and Decision data table
      )
    )
  )
)

# Server part of the dashboard
server <- function(input, output) {
  
  # Financial Data Table and Plot
  output$financialTable <- renderTable({
    tryCatch({
      req(financial_data)  # Ensure financial data is available
      financial_data
    }, error = function(e) {
      return(NULL)
    })
  })
  
  output$financialPlot <- renderPlot({
    ggplot(financial_data, aes(x = invoice_total_amount)) +
      geom_histogram(fill = "steelblue", bins = 20) +
      labs(title = "Distribution of Invoice Total Amount", x = "Invoice Total Amount", y = "Frequency") +
      theme_minimal()
  })
  
  # Prediction for Financial Data
  output$financialPredictionPlot <- renderPlot({
    # Use financial data for a regression prediction example (e.g., predicting total amount based on raw amount)
    data_for_model <- financial_data %>%
      filter(!is.na(invoice_total_amount), !is.na(raw_amount)) %>%
      select(invoice_total_amount, raw_amount)
    
    # Train-test split
    set.seed(3033)
    trainIndex <- createDataPartition(data_for_model$invoice_total_amount, p = .7, list = FALSE)
    trainData <- data_for_model[trainIndex,]
    testData <- data_for_model[-trainIndex,]
    
    # Train SVM Model
    svm_model <- svm(invoice_total_amount ~ ., data = trainData, kernel = "linear")
    
    # Predict on test data
    predictions <- predict(svm_model, testData)
    
    # Plot predictions
    ggplot(data.frame(Actual = testData$invoice_total_amount, Predicted = predictions), aes(x = Actual, y = Predicted)) +
      geom_point(color = "red") +
      labs(title = "Financial Prediction: Actual vs Predicted", x = "Actual Total Amount", y = "Predicted Total Amount") +
      theme_minimal()
  })
  
  # Project Management Data Table and Pie Chart for GYR Constraint
  filtered_data <- reactive({
    req(input$project)
    project_management_data %>% 
      filter(project_name == input$project)
  })
  
  output$gyrPieChart <- renderPlot({
    req(filtered_data())
    gyr_data <- filtered_data() %>%
      count(gyr_constraint) %>%
      mutate(percentage = n / sum(n))
    
    ggplot(gyr_data, aes(x = "", y = percentage, fill = gyr_constraint)) +
      geom_bar(stat = "identity", width = 1) +
      coord_polar(theta = "y") +
      labs(title = paste("GYR Constraint Distribution for", input$project), 
           x = "", y = "Proportion") +
      theme_minimal()
  })
  
  output$gyrTable <- renderTable({
    filtered_data() %>%
      group_by(gyr_constraint) %>%
      summarize(description = paste(unique(risk_description), collapse = ", "), 
                milestones = paste(unique(milestone_description), collapse = ", "))
  })
  
  # Prediction for Project Management (based on GYR constraints)
  output$projectPredictionPlot <- renderPlot({
    # Use project data to predict GYR constraint proportion
    gyr_data <- filtered_data() %>%
      count(gyr_constraint) %>%
      mutate(percentage = n / sum(n))
    
    # Plot predicted proportions (simple as actual)
    ggplot(gyr_data, aes(x = gyr_constraint, y = percentage, fill = gyr_constraint)) +
      geom_bar(stat = "identity") +
      labs(title = "Predicted GYR Constraint Distribution", x = "GYR Constraint", y = "Proportion") +
      theme_minimal()
  })
  
  # Risk Management Data Table and Plot
  output$riskManagementTable <- renderTable({
    tryCatch({
      req(risk_management_data)  # Ensure risk management data is available
      risk_management_data
    }, error = function(e) {
      return(NULL)
    })
  })
  
  output$riskPlot <- renderPlot({
    ggplot(risk_management_data, aes(x = risk_impact)) +
      geom_histogram(fill = "darkred", bins = 10) +
      labs(title = "Risk Impact Distribution", x = "Risk Impact", y = "Frequency") +
      theme_minimal()
  })
  
  # Prediction for Risk Management
  output$riskPredictionPlot <- renderPlot({
    # Use risk management data for SVM classification on risk impact
    data_for_model <- risk_management_data %>%
      filter(!is.na(risk_impact)) %>%
      select(risk_impact, project_id)
    
    # Train-test split
    set.seed(3033)
    trainIndex <- createDataPartition(data_for_model$risk_impact, p = .7, list = FALSE)
    trainData <- data_for_model[trainIndex,]
    testData <- data_for_model[-trainIndex,]
    
    # Train SVM Model
    svm_model <- svm(risk_impact ~ ., data = trainData, kernel = "linear")
    
    # Predict on test data
    predictions <- predict(svm_model, testData)
    
    # Plot predictions vs actual
    ggplot(data.frame(Actual = testData$risk_impact, Predicted = predictions), aes(x = Actual, y = Predicted)) +
      geom_point(color = "blue") +
      labs(title = "Risk Prediction: Actual vs Predicted", x = "Actual Risk Impact", y = "Predicted Risk Impact") +
      theme_minimal()
  })
}

# Run the app
shinyApp(ui = ui, server = server)

