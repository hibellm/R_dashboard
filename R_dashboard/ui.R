## ui.R ##

# theme = "https://cdn.jsdelivr.net/npm/fomantic-ui@2.8.5/dist/semantic.min.css"

dashboardPage(
  dashboardHeader(title="DSI Portal"),
  dashboardSidebar(
    sliderInput("bins","Number of bins:",min = 1,max = 100, value = 30),

    
     sidebarMenu(id="mysidebar",
                 conditionalPanel(
                   condition = "name.password != 'password'",
                   passwordInput("passwd", placeholder="Password", label = tagList(icon("lock"), "DSI Password")),
                   verbatimTextOutput("value"),
                   menuItem(h3("Guest Menu")),
                   menuItem("About",icon=icon("question-circle"),tabName = "about"),
                 ),                 
                 menuItem(h3("Summaries")),
                 menuItem(h3("Guest Menu")),
                 menuItem("Summary",icon=icon("book"),tabName = "summary"),
                 menuItem("Documentation",icon=icon("book"),tabName = "documentation",badgeLabel = "new", badgeColor = "green"),
                 conditionalPanel(
                   condition = "name.password == 'password'",
                   menuItem("About",icon=icon("question-circle"),tabName = "about")
                   ),

        menuItem("About",icon=icon("question-circle"),tabName = "about"),
        menuItem(h3("DSI member Menu")),
        menuItem("Metrics",icon=icon("tasks"),tabName = "metric1"),
        menuItem("Deliverables",icon=icon("truck"),tabName = "deliveries"),
        menuItem("WIP",icon=icon("tasks"),tabName = "wip"),
        menuItem("Data",icon=icon("database"),tabName = "SourceData")
         )
    # sliderInput("bins","Number of bins:",min = 1,max = 100, value = 30),
  ),
  dashboardBody(
    tags$head(title="DSI PORTAL MJH",
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
                  valueBoxOutput('jirac',width=4)
                  )
              ),
      tabItem(tabName = "wip",
              h1("Jira Status")
              ),
      tabItem(tabName = "SourceData",
              h1("Source Data"),
              fluidRow(DTOutput('sourcedata'))
              ),      
      tabItem(tabName = "deliveries",
              h1("Deliveries"),
              sliderInput("obs", "Number of observations:", min = 0, max = 1000, value = 500)
              ),
      tabItem(tabName = "documentation",
              h1("this is about the DSI portal")
              ),      
      tabItem(tabName = "about",
              h1("this is about the DSI portal")
              )
    )
  )#endofbody
)#endofpagey
