## ui.R ##
# library(shinydashboard)
# library(shinyWidgets)
# library(shinyjs)
# library(DT)

# theme = "https://cdn.jsdelivr.net/npm/fomantic-ui@2.8.5/dist/semantic.min.css"

dashboardPage(
  dashboardHeader(title=HTML("<i class='ui icon dragon large'></i>    DSI Portal"),
                  dropdownMenuOutput("messages"), dropdownMenuOutput("notifications"), dropdownMenuOutput("tasks")
                  ),
  dashboardSidebar(
    passwordInput("password", placeholder="Password", label = tagList(icon("lock"), "DSI Password")),
    uiOutput("userpanel")
  ),
  dashboardBody(
    tags$head(title="DSI PORTAL",
              tags$link(rel = "stylesheet", type = "text/css", href = "https://cdn.jsdelivr.net/npm/fomantic-ui@2.8.6/dist/semantic.min.css"),
              tags$link(rel = "stylesheet", type = "text/css", href = "myassets/css/tree.css"),
              useShinyjs(),
              shinyFeedback::useShinyFeedback()
              # tags$script(src="https://cdn.jsdelivr.net/npm/jquery@3.3.1/dist/jquery.min.js"),
              # tags$script(src="https://cdn.jsdelivr.net/npm/fomantic-ui@2.8.6/dist/semantic.min.js"),
              # tags$script("$('.ui.accordion').accordion();")
              
    ),    
    tabItems(
      tabItem(tabName="summary",
              fluidRow(
                box(plotOutput("histogram")),
                box(radioButtons("color",h3("Select Colour:"),choices=list("Red"=2,"green" = 3,"Blue" = 4),selected=2)),
                sliderInput("bins","Number of bins:",min = 1,max = 100, value = 30),
                dateRangeInput("daterange1", "Date range:",
                               start = Sys.Date()-100,
                               end   = Sys.Date(),
                               max = Sys.Date()),
                textOutput('dtrange'),
                actionButton(inputId = "Id103",label = NULL,style = "material-circle", color = "danger",icon = icon("download")
                )
                
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
                  valueBoxOutput('jirac',width=4)
                  )
              ),
      tabItem(tabName = "wip",
              h1("Jira Status"),
              uiOutput("statboxes")
              ),
      tabItem(tabName = "SourceData",
              h1("Source Data"),
              fluidRow(DTOutput('sourcedata'))
              ),      
      tabItem(tabName = "deliveries",
              h1("DSI Deliveries"),
              sliderInput("obs", "Number of observations:", min = 0, max = 1000, value = 500)
              ),
      tabItem(tabName = "documentation",
              h1("DSI Documentation portal"),
              actionButton(inputId = 'success2',label = 'Launch a success sweet alert',icon = icon('check')),
              fluidRow(timevisOutput("timeline"))
              ),  
      tabItem(tabName = "about",
              h1("this is about the DSI portal"),
              h4("some description of DSI could go here"),
              tabsetPanel(type = "tabs",
                          tabPanel(tabname="about_msn", HTML("<i class='ui icon user secret large'></i>Mission"), uiOutput("msn")),
                          tabPanel(tabname="about_org", HTML("<i class='ui icon users large'></i>Organogram"), uiOutput("org")),
                          tabPanel(tabname="about_wel", HTML("<i class='flag uk'></i>Welwyn"), uiOutput("wel")),
                          tabPanel(tabname="about_bsl", HTML("<i class='flag ch'></i>Basel"), uiOutput("bsl")),
                          tabPanel(tabname="about_oth", HTML("<i class='ui icon globe large'></i>Other"), uiOutput("oth"))
              )
      )
    )
  )
)
