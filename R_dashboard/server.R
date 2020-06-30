library(shiny)
library(shinydashboard)
library(tidyverse)
library(DT)
library(dash)
library(plotly)
library(scales)
library(shinyjs)
library(RMySQL)
library(mongolite)
library(jsonlite)


# MAKE CONNECTIONS TO THE DATABASES
# source("database.R")
# DATABASE CONNECTIONS AND MANIPULATIONS
con <- dbConnect(MySQL(),user = 'root',password = 'root',host = 'localhost',dbname='dsi')
jira <- dbReadTable(con, "jira")
mcon <- mongo(collection = "metrics", db = "dsi")


shinyServer(function(input, output, session) {
  
  # MAKE SOME SUMMARY TO THE DATA FOR DISPLAY
  iris2 <- as.data.frame(iris)
  iris2['mjh'] <- 1:nrow(iris2)
  iris2['test'] <- 1:nrow(iris2)
  
  
  # VALUES TO DISPLAY IN VALUE BOXES
  output$jirao <- renderValueBox({
    valueBox(dplyr::summarise(iris, avg = mean(Sepal.Length)),"Open",icon=icon("slideshare"),color="green")
  })  
  output$jirai <- renderValueBox({
    valueBox(10,"In Progress",icon=icon("cogs"),color="yellow")
  })  
  output$jirac <- renderValueBox({
    valueBox(17,"Closed",icon=icon("check-square"),color="red")
    }) 
  
  # PLOTS
  output$histogram <- renderPlot({
    hist(faithful$eruptions,breaks=input$bins,col=input$color)
  })
  
  # TABLES
  output$sourcedata <- renderDT({
    # ADD BUTTON TO THE TABLE    
    datatable(iris2,
                options = list(columnDefs = list(
                  list(
                    targets = which(names(iris2) == "mjh"),
                    render = JS(
                      "function(data, type, row, meta) { ",
                      "return '<i id=\"coords' + data + '\" class=\"ui icon info circle inverted blue\"></i>'",
                      "}")),
                  list(
                    targets = which(names(iris2) == "test"),
                    render = JS(
                      "function(data, type, row, meta) { ",
                      "return '<i id=\"test' + data + '\" class=\"ui icon info circle inverted red\" data-fulltext=\"'+data+'\"></i>'",
                      "}"))
                )),
              )
  })
  

  # Create a function to write a csv file.
  new.function <- function(i) {
    print(paste("data entered",i))
    write.csv(iris2, file.path(getwd(),"iris_mjh.csv"), row.names = FALSE)
    # ENTER INFO INTO MONGDB
    # GET THE ROW DATA
    str <- c(paste('{"request": {
    "userId": "hibellm",
    "age" : ',i,',
    "date_data":{"$date":"2020-12-14T12:12:12+0100"}}}'))
    mcon$insert(str)
    print(paste("data entered",i))
    }
  
  new.function2 <- function(j) { print(paste("the value is",j))}

  
  
  
  # CONDITONAL PANELS  
  output$userpanel <- renderUI({
    # DSI MEMBERS
    if (input$password == 'password') {
      sidebarMenu(
        menuItem("Logged in as " ,badgeLabel = "DSI member", badgeColor = "blue"),
        menuItem(h3("DSI Menu")),
        menuItem("Metrics",icon=icon("tasks"),tabName = "metric1"),
        menuItem("Summary",icon=icon("book"),tabName = "summary"),
        menuItem("Documentation",icon=icon("book"),tabName = "documentation",badgeLabel = "new", badgeColor = "green"),
        menuItem("Deliverables",icon=icon("truck"),tabName = "deliveries"),
        menuItem("WIP",icon=icon("tasks"),tabName = "wip"),
        menuItem("Data",icon=icon("database"),tabName = "SourceData"),
        menuItem("About",icon=icon("question-circle"),tabName = "about")
      )
    }
    # GUEST
    else if (input$password != 'password') {
      sidebarMenu(
        menuItem("Logged in as ", badgeLabel = "Guest", badgeColor="yellow"),
        menuItem(h3("Guest Menu")),
        menuItem("Metrics",icon=icon("tasks"),tabName = "metric1"),
        menuItem("Summary",icon=icon("book"),tabName = "summary"),
        menuItem("Documentation",icon=icon("book"),tabName = "documentation",badgeLabel = "new", badgeColor = "green"),
        menuItem("About",icon=icon("question-circle"),tabName = "about")
      )
    }
  })
  
  
  
  
  
})

dbDisconnect(con)
  
