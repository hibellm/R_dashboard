
# MAKE SOME SUMMARY TO THE DATA FOR DISPLAY
iris2 <- as.data.frame(iris)
iris2['mjh'] <- 1:nrow(iris2)
iris2['test'] <- 1:nrow(iris2)
iris2$id_ <- 1:nrow(iris2)


# THE SHINY SERVER CODE 
shinyServer(function(input, output, session) {

  
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
  
  
  #DATE RANGE
  observeEvent(input$daterange1, {
    a<-input$daterange1
    print(paste('The date range value is ', a[[1]]) )
  })
  
  output$dtrange <- renderText({
    b<-input$daterange1
    
    if (b[[1]] > b[[2]]){
      print('The star date range value is after the end date range!  ' )
    } else {
      print(paste('The date range value is ', b[[1]],'The date range value is ', b[[2]]))
    }
  })
  
  
  # PLOTS
  output$histogram <- renderPlot({
    hist(faithful$eruptions,breaks=input$bins,col=input$color)
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

  
  # TASKS
  tlist<-mcon2$find()
  tasks <- vector("list")
  for(i in 1:nrow(tlist)) { 
    tasks[[i]] <- list(
      value = tlist[[1]][i],
      color = tlist[[2]][i],
      text = tlist[[3]][i]
    ) 
  }
  output$tasks <- renderMenu({
    titems <- lapply(tasks, function(el) {
      taskItem(value = el$value, color = el$color, text = el$text)
    })
    dropdownMenu(
      type = "tasks", badgeStatus = "danger", .list = titems
    )
  })
  
  # NOTIFICATIIONS
  nlist<-mcon3$find()
  notes <- vector("list")
  for(i in 1:nrow(nlist)) { 
    notes[[i]] <- list(
      icon = icon(nlist[[1]][i]),
      status = nlist[[2]][i],
      text = nlist[[3]][i]
    ) 
  }
  output$notifications <- renderMenu({
    nitems <- lapply(notes, function(el) {
      notificationItem(icon = el$icon, status = el$status, text = el$text)
    })
    dropdownMenu(
      type = "notifications", .list = nitems
    )
  })
  
  # MESSAGES
  mlist<-mcon4$find()
  msg <- vector("list")
  for(i in 1:nrow(mlist)) { 
    msg[[i]] <- list(
      from = mlist[[1]][i],
      message = tags$span(tags$a(href="https://www.rstudio.com", mlist[[2]][i])),
      icon = icon(mlist[[3]][i]),
      time = mlist[[4]][i]
    ) 
  }
  output$messages <- renderMenu({
    mitems <- lapply(msg, function(el) {
      messageItem(from = el$from, message = el$message, icon = el$icon, time = el$time)
    })
    dropdownMenu(
      type = "messages", .list = mitems
    )
  })
  
  

  # CONDITONAL PANELS
  # output$headerpanel <- renderUI({
  #   # DSI MEMBERS
  #   if (input$password == 'password') {
  #     dashboardHeader(title="DSI Portal", messages, notifications, tasks)
  #   }
  #   # GUEST
  #   else if (input$password != 'password') {
  #     dashboardHeader(title="DSI Portal")
  #   }
  # })
  
  output$userpanel <- renderUI({
    # DSI MEMBERS
    if (input$password == 'q') {
      sidebarMenu(
        menuItem("Logged in as " ,badgeLabel = "DSI member", badgeColor = "blue"),
        menuItem(h3("DSI Menu")),
        menuItem("Metrics",icon=icon("tasks"),tabName = "metrics1"),
        menuItem("Summary",icon=icon("book"),tabName = "summary"),
        menuItem("Documentation",icon=icon("book"),tabName = "documentation", badgeLabel = "new", badgeColor = "green"),
        menuItem("Deliverables",icon=icon("truck"),tabName = "deliveries"),
        menuItem("WIP",icon=icon("tasks"),tabName = "wip"),
        menuItem("Data",icon=icon("database"),tabName = "SourceData"),
        menuItem("About",icon=icon("question-circle"),tabName = "about")
      )
    }
    # GUEST
    else if (input$password != 'q') {
      sidebarMenu(
        menuItem("Logged in as ", badgeLabel = "Guest", badgeColor="yellow"),
        menuItem(h3("Guest Menu")),
        menuItem("Testing of data",icon=icon("table"),tabName = "datatest"),
        menuItem("Testing of data",icon=icon("table"),tabName = "datatest2"),
        menuItem("Metrics",icon=icon("tasks"),tabName = "metrics1"),
        menuItem("Summary",icon=icon("book"),tabName = "summary"),
        menuItem("Documentation",icon=icon("book"),tabName = "documentation", badgeLabel = "new", badgeColor = "green"),
        menuItem("About",icon=icon("question-circle"),tabName = "about")
      )
    }
  })

  # ABOUT
  # output$abouttab <- renderUI({
  #   tabItem(tabName = "about",
  #           h1("this is about the DSI portal"),
  #           h4("some description of DSI could go here"),
  #           tabsetPanel(type = "tabs",
  #                       tabPanel(HTML("<i class='ui icon users large'></i>Organogram"), uiOutput("org")),
  #                       tabPanel(HTML("<i class='flag uk'></i>Welwyn"), uiOutput("wel")),
  #                       tabPanel(HTML("<i class='flag ch'></i>Basel"), uiOutput("bsl")),
  #                       tabPanel(HTML("<i class='ui icon globe large'></i>Other"), uiOutput("oth"))
  #           )
  #   )
  # })
  
  # IMPORTING THE CODE FROM SEPARATE FILE
  

    # ORGANOGRAM CODE
  output$msn <- renderUI({
    h4("MJHMJHMJHsome description of DSI could go here")
  })
  # ORGANOGRAM CODE
  output$org <- renderUI({
    div(h5("Rebecca Sudlow"),br(),"DSI Management")
    includeHTML("tab-org.html")
  })
  # ABOUT_WEL CODE
  output$wel <- renderUI({
    div(h5("Rebecca Sudlow"),br(),"DSI Management")
    includeHTML("tab-wel.html")
  })
  # ABOUT_BSL CODE
  output$bsl <- renderUI({
    div(h5("Rebecca Sudlow"),br(),"DSI Management")
    includeHTML("tab-bsl.html")
  })  
  # ABOUT_OTH CODE
  output$oth <- renderUI({
    div(h5("Rebecca Sudlow"),br(),"DSI Management")
    includeHTML("tab-oth.html")
  })  
  # REDIRECTS
  observeEvent(input$org_wel, {
    updateTabItems(session, "org_wel", "about_wel")
  })  
 
  output$statboxes <- renderUI({
    fluidRow(
             valueBox("total_today","12","Tweets Today",color = "purple",icon = icon("comment-dots"),width = 4),
             valueBox("tweeters_today","32", "Tweeters Today",color = "orange",icon = icon("user-circle"),width = 4),
             valueBox("rate","2.3", "Tweets/hr Today",color = "green",icon = icon("hourglass-half"),width = 4)
    )
  })
  
  output$groupsicon <- renderUI({
    box(
      title = "User List example",
      status = "success",
      width = NULL,
      userList(
        userListItem(
          src = "https://www.rstudio.com/wp-content/uploads/2014/04/shiny.png", 
          user_name = "Shiny", 
          description = "28.04.2018"
        ),
        userListItem(
          src = "https://www.rstudio.com/wp-content/uploads/2014/04/knitr.png", 
          user_name = "knitr", 
          description = "28.04.2018"
        ),
        userListItem(
          src = "https://www.rstudio.com/wp-content/uploads/2017/05/rmarkdown.png", 
          user_name = "Rmarkdown", 
          description = "28.04.2018"
        ),
        userListItem(
          src = "https://d33wubrfki0l68.cloudfront.net/071952491ec4a6a532a3f70ecfa2507af4d341f9/c167c/images/hex-dplyr.png", 
          user_name = "Tidyverse", 
          description = "28.04.2018"
        ),
        userListItem(
          src = "https://www.rstudio.com/wp-content/uploads/2014/04/tidyr.png", 
          user_name = "tidyr", 
          description = "28.04.2018"
        ),
        userListItem(
          src = "https://www.rstudio.com/wp-content/uploads/2014/04/packrat.png", 
          user_name = "packrat", 
          description = "28.04.2018"
        ),
        userListItem(
          src = "https://www.rstudio.com/wp-content/uploads/2014/04/sparklyr.png", 
          user_name = "packrat", 
          description = "28.04.2018"
        )
      )
    )
  })
  
  output$person1 <- renderUI({
    widgetUserBox(
      title = "Elizabeth Pierce",
      subtitle = "Web Designer",
      type = NULL,
      width = 12,
      src = "./myassets/images/banners/th1.jpg",
      background = TRUE,
      backgroundUrl = "./myassets/images/banners/th1.jpg?auto=compress&cs=tinysrgb&h=350",
      closable = FALSE,
      "Some text here!",
      footer = "The footer here!"
    )
  })
  
  output$person2 <- renderUI({
    widgetUserBox(
      title = "Elizabeth Pierce",
      subtitle = "Web Designer",
      type = NULL,
      width = 12,
      src = "./myassets/images/banners/th1.jpg",
      background = TRUE,
      backgroundUrl = "./myassets/images/banners/th1.jpg?auto=compress&cs=tinysrgb&h=350",
      closable = FALSE,
      "Some text here!",
      footer = "The footer here!"
    )
  })
  output$person3 <- renderUI({
    widgetUserBox(
      title = "Elizabeth Pierce",
      subtitle = "Web Designer",
      type = NULL,
      width = 12,
      src = "./myassets/images/banners/th1.jpg",
      background = TRUE,
      backgroundUrl = "./myassets/images/banners/th1.jpg?auto=compress&cs=tinysrgb&h=350",
      closable = FALSE,
      "Some text here!",
      footer = "The footer here!"
    )
  })
  output$person4 <- renderUI({
    widgetUserBox(
      title = "Elizabeth Pierce",
      subtitle = "Web Designer",
      type = NULL,
      width = 12,
      src = "./myassets/images/banners/th2.jpg",
      background = TRUE,
      backgroundUrl = "./myassets/images/banners/th2.jpg?auto=compress&cs=tinysrgb&h=350",
      closable = FALSE,
      "Some text here!",
      footer = "The footer here!"
    )
  })
  
    
  
  # TIMELINE
  data <- data.frame(
    id      = 1:4,
    content = c("Item one", "Item two"  ,"Ranged item", "Item four"),
    start   = c("2016-01-10", "2016-01-11", "2016-01-20", "2016-02-14 15:00:00"),
    end     = c(NA          ,           NA, "2016-02-04", NA)
  )
  data2<-tlcon$find()
  
  output$timeline <- renderTimevis({
    # THE TIMELINE CONFIGURATION
    config <- list(
      editable = FALSE,
      align = "center",
      orientation = "top",
      snap = NULL,
      margin = list(item = 30, axis = 50)
    )
    
    timevisDataGroups <- data.frame(
      id = c("viv", "int", "ext"),
      content = c("Vivli Requests", "Internal Requests", "External Requests")
    )
    
    timevis(data2,
              groups = timevisDataGroups,
              options = config)
    })
  
  observeEvent(input$success, {
    show_alert(
      title = HTML("Success1 !!<hr><p><h1>heading 1</h1><h5<heading 1</h5><table></table>"),
      text = "Success1 !!",
      type = "success",
      html = TRUE
    )
  })
  
  observeEvent(input$success2, {
    show_alert(
      title = "Success2 !!",
      text = tags$span(
        tags$h3("With HTML tags",
                style = "color: steelblue;"),"In",
        tags$b("bold"), "and", tags$em("italic"),
        tags$br(),"and",
        tags$br(),"line",
        tags$br(),"breaks",
        tags$br(),"and an icon", icon("thumbs-up")
      ),
      html = TRUE,
      type = "success"
    )
  })  
  
  
  
  
  
  
  
  
  
  
  # Call the server function portion of the `cars_table_module.R` module file
  callModule(
    cars_table_module,
    "cars_table"
  )
  
  
  # RENDERS THE TABLE
  output$mjh <- renderDT({
    
    out <- conn$find() %>%
      dplyr::mutate(created_at = as.POSIXct(Sys.Date(), tz = "UTC"),
                    modified_at = as.POSIXct(Sys.Date(), tz = "UTC"),
                    created_by = 'Me',
                    modifed_by = '') %>%
      collect()
    
    datatable(
      out,
      rownames = FALSE,
      # colnames = c('Model', 'Miles/Gallon', 'Cylinders', 'Displacement (cu.in.)',
      #              'Horsepower', 'Rear Axle Ratio', 'Weight (lbs)', '1/4 Mile Time',
      #              'Engine', 'Transmission', 'Forward Gears', 'Carburetors', 'Created At',
      #              'Created By', 'Modified At', 'Modified By'),
      colnames = c('Sepal Length', 'Sepal Width', 'Petal Length', 'Petal Width', 'Species', 'mjh','test','id_','Created At',
                   'Modified At', 'Created By', 'Modified By'),
      selection = "none",
      class = "compact stripe row-border nowrap",
      # Escape the HTML in all except 1st column (which has the buttons)
      escape = -1,
      extensions = c("Buttons"),
      options = list(
        scrollX = TRUE,
        dom = 'Bftip',
        buttons = list(
          list(
            extend = "excel",
            text = "Download",
            title = paste0("mtcars-", Sys.Date()),
            exportOptions = list(
              columns = 1:(length(out) - 1)
            )
          )
        ),
        columnDefs = list(
          list(targets = 0, orderable = FALSE)
        )
      )
    ) #%>%
      # formatDate(
      #   columns = c("Created At", "Modified At"),
      #   method = 'toLocaleString'
      # )
    
  })
  
  
  
  
})

  
