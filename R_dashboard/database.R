# DATABASE CONNECTIONS AND MANIPULATIONS

con <- dbConnect(MySQL(),user = 'root',password = 'root',host = 'localhost',dbname='dsi')
jira <- dbReadTable(con, "jira")
mcon <- mongo(collection = "metrics", db = "dsi") # create connection, database and collection