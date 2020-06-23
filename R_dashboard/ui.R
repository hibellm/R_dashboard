## ui.R ##

#theme = "https://cdn.jsdelivr.net/npm/semantic-ui@2.4.2/dist/semantic.min.css"
theme = "https://cdn.jsdelivr.net/npm/fomantic-ui@2.8.5/dist/semantic.min.css"

dashboardPage(
  dashboardHeader(title="DSI Portal"
                  ),
  
  
  dashboardSidebar(
    sidebarMenu(
      menuItem(h3("Summaries")),
      menuItem("Summary",icon=icon("book"),tabName = "summary"),
      menuItem("Metrics",icon=icon("tasks"),tabName = "metrics"),
      menuItem("Deliverables",icon=icon("truck"),tabName = "deliveries"),
      menuItem("WIP",icon=icon("tasks"),tabName = "wip"),
      menuItem("Data",icon=icon("database"),tabName = "SourceData"),
      menuItem("About",icon=icon("question-circle"),tabName = "about")
    ),
    sliderInput("bins","Number of bins:",min = 1,max = 100, value = 30)    
  ),
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "https://cdn.jsdelivr.net/npm/fomantic-ui@2.8.5/dist/semantic.min.css"),
      useShinyjs()
    ),    
    tabItems(
      tabItem(tabName="summary",
              fluidRow(
                box(plotOutput("histogram")),
                box(radioButtons("color",h3("Select Colour:"),choices=list("Red"=2,"green" = 3,"Blue" = 4),selected=2))
              )      
      ),
      tabItem(tabName = "metrics",
              h1("Transcelerate Metrics"),
              div(class="ui container",
                img(src="assets/images/banners/th1.jpg", class="ui centered aligned huge"),
                h1("TransCelerate PSoC"),
                div(class="ui inverted segment"),
                  box("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum")),
              box(valueBoxOutput('jirao',width=4),
                  valueBoxOutput('jirai',width=4),
                  valueBoxOutput('jirac',width=4))
      ),
      tabItem(tabName = "wip",
              h1("Jira Status"),
              fluidRow(
                p("The first checkbox group controls the second"),
                checkboxGroupInput("inCheckboxGroup", "Input checkbox",
                                   # c("Item A", "Item B", "Item C"),
                                   c(x),
                                   inline = TRUE),
                checkboxGroupInput("inCheckboxGroup2", "Input checkbox 2",
                                   c("Item A", "Item B", "Item C"))
              ),
              
      ),
      tabItem(tabName = "SourceData",
              h1("Source Data"),
              fluidRow(DTOutput('sourcedata'))
      ),      
      tabItem(tabName = "deliveries",
              h1("Deliveries"),
              sliderInput("obs", "Number of observations:",
                          min = 0, max = 1000, value = 500
              )
      ),
      tabItem(tabName = "about",
              h1("this is about the DSI portal")

    )
    )
  )#endofbody
)#endofpagey


#dbDisconnect(con)
