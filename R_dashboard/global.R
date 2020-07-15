# GLOBAL OPTIONS ARE SET HERE

# library in packages used in this application
library(shiny)
library(shinydashboard)
library(shinycssloaders)
library(shinyjs)
library(shinyFeedback)
library(shinyWidgets)
library(tidyverse)
#PLOTTING
library(dash)
library(plotly)
library(scales)
library(timevis)
#TABLULATIONS
library(DT)
#DATABASE
library(DBI)
library(RSQLite)
library(RMySQL)
library(mongolite)
#UTILITY
library(lubridate)
library(dplyr)
library(dbplyr)
library(jsonlite)


setwd("E:/projects/R_dashboard/R_dashboard")

# CAN LOAD CODE TO BE SHARED ACROSS HERE

# source('all_sessions.R', local=TRUE)

# END OF SHARED CODE

db_config <- config::get()$db


# DATABASE CONNECTIONS AND MANIPULATIONS
# SQL
con <- dbConnect(MySQL(),user = 'root',password = 'root',host = 'localhost',dbname='dsi')
jira <- dbReadTable(con, "jira")

# MONGODB
mcon <- mongo(collection = "metrics", db = "dsi")
# mcon2 <- mongo(collection = "task", db = "dsi")
# mcon3 <- mongo(collection = "notifications", db = "dsi")
# mcon4 <- mongo(collection = "messages", db = "dsi")
tnmcon <- mongo(collection = "tsknotmsg", db = "dsi")
tlcon <- mongo(collection = "timeline", db = "dsi")


# # Create database connection
# conn <- dbConnect(
#   RSQLite::SQLite(),
#   dbname = db_config$dbname
# )
# 
# # Stop database connection when application stops
# shiny::onStop(function() {
#   dbDisconnect(conn)
# })

# Turn off scientific notation
options(scipen = 999)

# Set spinner type (for loading)
options(spinner.type = 8)
