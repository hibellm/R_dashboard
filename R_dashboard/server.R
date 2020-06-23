
library(shiny)
library(shinydashboard)
library(RMySQL)
library(dplyr)
library(DT)
library(scales)
library(shinyjs)

con <- dbConnect(MySQL(),user = 'root',password = 'root',host = 'localhost',dbname='dsi')
jira <- dbReadTable(con, "jira")


shinyServer(function(input, output, session) {
  
  # MAKE SOME SUMMARY TO THE DATA FOR DISPLAY - USING DPYLR
  
  iris2 <- dplyr::tbl_df(iris)
  iris2['mjh'] = "coord"
  
  # dplyr::summarise(iris, avg = mean(Sepal.Length)) # MEAN VALUES OF SEPAL LENGTH
  # dplyr::count(iris, Species, wt = Sepal.Length)  # SUMS UP THE VALUES BY SPECIES
  # dplyr::first(iris, order_by = Species)  # SUMS UP THE VALUES BY SPECIES
  # dplyr::summarise(iris, first = first(Sepal.Length, order_by=(Species)))
  # 
  # # TAKE THE FIRST OF EACH SPECIES ORDERED BY SEPAL LENGTH
  # iris %>% group_by(Species) %>% dplyr::summarise(first = first(Sepal.Length, order_by=(Sepal.Length)))
  # iris %>% group_by(Species) %>% arrange(desc(Sepal.Length)) %>% dplyr::summarise(last = first(Sepal.Length))
  # iris %>% group_by(Species) %>% dplyr::summarise(last = last(Sepal.Length, order_by=(Sepal.Length)))
  # 
  # # FILTER THE DATA
  # dplyr::filter(iris, Sepal.Length > 7)
  # dplyr::distinct(iris)
  # dplyr::slice(iris, 10:15) # SELECT ROWS BY POSITION
  # dplyr::select(iris, Sepal.Width, Petal.Length, Species)
  
  
  output$histogram <- renderPlot({
    hist(faithful$eruptions,breaks=input$bins,col=input$color)
  })

  output$jirao <- renderValueBox({
    valueBox(dplyr::summarise(iris, avg = mean(Sepal.Length)),"Open",icon=icon("slideshare"),color="green")
  })  
  output$jirai <- renderValueBox({
    valueBox(10,"In Progress",icon=icon("cogs"),color="yellow")
  })  
  output$jirac <- renderValueBox({
    valueBox(17,"Closed",icon=icon("check-square"),color="red")
    }) 
  
  
  output$sourcedata <- renderDT({
    # WORKING EXAMPLE
    # datatable(iris[c(1:20, 51:60, 101:120), ],
    #           options = list(columnDefs = list(list(
    #             targets = 5,
    #             render = JS("function(data, type, row, meta) {",
    #                         "return type === 'display' && data.length > 6 ?",
    #                         "'<span title=\"' + data + '\">' + data.substr(0, 6) + '...</span>' : data;",
    #                         "}")))),
    # callback = JS('table.page(3).draw(false);')
    # )
    
  
    # ADD BUTTON TO THE TABLE    
    datatable(iris2,
              # extensions = c("Buttons"),
              # options = list(
              #   dom = 'Bfrtip',
              #   buttons = list("csv"),
                options = list(columnDefs = list(list(
                  targets = 6,
                  render = JS(
                    "function(data, type, row, meta) { ",
                    "return '<i id=\"' + data + '\" class=\"ui icon info circle inverted blue\"></i>'",
                    "}")))),
              )
  })
  
  # THERAPEUTIC AREA SLECTION
  output$specieslist<- renderText({
    x<-(dplyr::select(iris,Species) %>% distinct(Species))
  })
  output$value <- renderText({ input$somevalue })
  
  
  observe({
    x <- input$inCheckboxGroup
    
    # Can use character(0) to remove all choices
    if (is.null(x))
      x <- character(0)
    
    # Can also set the label and select items
    updateCheckboxGroupInput(session, "inCheckboxGroup2",
                             label = paste("Checkboxgroup label", length(x)),
                             choices = x,
                             selected = x
    )
  })
  

  # Create a function to write a csv file.
  new.function <- function() {
    write.csv(iris2,".\\iris_mjh.csv", row.names = FALSE)
    alert(date())
  }
  
  # Call the function without giving any argument.
  new.function()
  
  # JAVASCRIPT
  # shinyjs::onclick("coords", shinyjs::html("time", date()))
  # onclick("coords", function(event) { alert(event) })
  # onclick("coords", function(event) { alert("my text") })
  # onclick("coords", function(event) { alert(data(this)) })
  # onclick(".ui.icon", function(event) { new.function() })
  # onclick(expr = text("date", date()), id = "coords")
})

dbDisconnect(con)
  
