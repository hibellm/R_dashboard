# DATABASE CONNECTIONS AND MANIPULATIONS

con <- dbConnect(MySQL(),user = 'root',password = 'root',host = 'localhost',dbname='dsi')
jira <- dbReadTable(con, "jira")


library(mongolite)
library(jsonlite)
mcon <- mongo(collection = "metrics", db = "dsi") # create connection, database and collection



# SOME TEST CODE TO DEMONSTRATE MONGODB FUNCTIONS
var1<-c("a")
var2<-c(3)
var3<-list(c("A","B","C"))
var4<-list(c(3, 3.1, 1234.56))
var5<-c(as.POSIXlt('2002-06-09 12:45:40'))
var6<-list(c(as.POSIXlt('2002-06-09 12:45:40'),as.POSIXlt('2012-06-09 12:45:40')) )

# DF OF SIMPLE PAIR DATA
df <- data.frame( var1,var2,var5)
# DF OF LISTS
df[['var3']] <- var3
df[['var4']] <- var4
df[['var6']] <- var6
# NESING THE DF IN A VARIABLE
df[['var99']] <- df   

mcon$insert(df)


#FIND QUERIES
mcon$find()
mcon$find('{ "var1": { "$exists": true}}')
mcon$find('{ "var1": { "$exists": true, "$ne": "" } }')
mcon$find('{ "var3": { "$exists": true, "$ne": [] } }')
mcon$find('{ "var4": { "$exists": true, "$lt": 3 } }')
mcon$find('{ "var99":{ "var4": {"$exists": true} } }')
mcon$find('{ "var99.var4": { "$exists": true,"$ne": []} }')

# THIS STRING WORKS
mcon$update('{ "var3": { "$exists": true, "$ne": [] } }','{"$set":{"var4": ["x","y","z"]}}')


mcon$insert(toJSON(str))
dput(as.character(mylist$abc))

mcon$insert(cat(paste('{"mh": [',paste(shQuote(mylist$abc, type="cmd"), collapse=", "),']}')))


L3 <- LETTERS[1:3]
fac <- sample(L3, 10, replace = TRUE)
(d <- data.frame(x = 1, y = 1:10, fac = fac))
## The "same" with automatic column names:
df<-data.frame(1, 1:10, list('xyz'= c(1,2,3)))


taskItem(value = 90, color = ["green","Documentation")
taskItem(value = 17, color = ["aqua","Project X")
taskItem(value = 75, color = "yellow","Server deployment")
taskItem(value = 80, color = "red","Overall project")


# TWO DF OF DIFFERENT SIZEs (hawk has missing column)

eagle <- tibble::rowid_to_column(iris, "ID")

hawk <- tibble::rowid_to_column(iris[-c(3)], "ID")
hawk <- as.data.frame(cbind(hawk,ifelse(hawk$Sepal.Length > 5.2, 5.5,hawk$Sepal.Length)))

# MERGE THE TWO DF - PETAL.LENGTH IS NOT IN ONE OF THE DFs SO GETS NOT SUFFIX
merged_df <- merge.data.frame(eagle, hawk, by.x=1, by.y=1,sort=FALSE, suffixes=c('E','H'))

# ORDER THE VARIABLES (NOTE 4 IS THE ONE WITHOUT A MATCH - SO PUTTING AT END)
o_df <- merged_df[,c(1,2,7,3,8,5,9,6,10,4)]

# COMPARE - MAKE A MATCH COLUMN FOR THOSE IN COMMON

ifelse(o_df$Sepal.LengthE==merged_df$Sepal.LengthH,1,0)
ifelse(o_df[,2]==o_df[,3],1,0)

c_df <- as.data.frame(cbind(o_df,ifelse(o_df$Sepal.LengthE==merged_df$Sepal.LengthH,1,0)))





employee <- c('John Doe','Peter Gynn','Jolie Hope')
salary <- c(21000, 23400, 26800)
age <- c(21, 23, 26)
wt <- c(20, 23, 26)
job <- c('boss','worker','student')
df_dog <- data.frame(employee, salary,age,wt, job)

employee <- c('John Doe','Peter Gynn','Jolie Hope')
salary <- c(21000, 23400, 26801)
age <- c(20, 23, 26)
wt <- c(20, 23, 26)
locale <- c('welwyn','basel','ssf')
name <- c('fluffy','tinkerbell','paws')

df_cat <- data.frame(employee, salary,age,wt,locale, name)

# MERGE THE DATA FRAMES - NOTE LOCALE AND JOB  ARE NOT IN COMMON SO GET NO SUFFIX!
df_compare <- merge.data.frame(df_dog,df_cat, by.x=1, by.y=1, sort=FALSE, suffixes=c("_dog","_cat"))

# COMPARE THE ROWS - 0/1=NO MATCH/MATCH

# LIST OF THE COLUMN NAMES IN EACH DF
colsd<- colnames(df_dog)
colsc<- colnames(df_cat)

# LIST OF COLUMNS IN COMMON OF THE TWO DFs
cols<-Reduce(intersect, list(colsd,colsc))
# COLUMNS ONLY IN DOG/CAT
colsd_only<-Reduce(setdiff, list(colsd,cols))
colsc_only<-Reduce(setdiff, list(colsc,cols))


# LOOP THROUGH THE LIST OF COLUMNS IN COMMON - IGNORING THE EMPLOYEE COLUMN AS I MERGED ON THAT
matchcol<-c('employee')
for (col in cols){
  print(col)
  if (col == 'employee') {
  } else {
    df_compare[paste0(col,'_match')]<-ifelse(df_compare[paste0(col,'_dog')]==df_compare[paste0(col,'_cat')],1,0)
    collist<-c(paste0(col,'_dog'),paste0(col,'_cat'),paste0(col,'_match'))
    matchcol<-append(matchcol,collist)
  }
}

# ORDERED COLUMNS (JUST THE ONCE WITH A COMPARISON + COMPARISON AND DOG/CAT ONLY COLUMNS)
o_df<-df_compare[,c(matchcol)]
o2_df<-df_compare[,c(matchcol,colsd_only, colsc_only)]































