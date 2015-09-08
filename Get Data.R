## Getting and Cleaning Data Algorithm
library(RCurl)
library(jsonlite)
library(xml2)

## first pull in list of SNL alumni and Daily show alumni, wikepedia

SNLurl <- "https://en.wikipedia.org/wiki/Saturday_Night_Live_cast_members"
tabs_SNL <- getURL(SNLurl)
tab_SNL <- readHTMLTable(tabs_SNL)
sub_SNL <- tab_SNL[[2]]
SNL_actors <- as.character(sub_SNL[,1])
## modifying year formats, may need for loop for 
SNL_actors_years <- as.character(sub_SNL[,2])

actors <- character()
StartYear <- character()
LastYear <- character()
count <- 0
for(i in 1:length(SNL_actors_years)) {
  n <- nchar(SNL_actors_years[i])/9
  if (n < 1) {n <- ceiling(n)}
  else if (n <2 & 2>1) {n <- floor(n)}
  rows <- i+n-1
  
  for(a in 1:n){
  count <- count +1
  actors[count] <- SNL_actors[i]
  
  StartYear[count] <- substr(SNL_actors_years[i], 1 + (a-1)*9, 4+(a-1)*9)

LastYear[count] <- substr(SNL_actors_years[i], 6 +(a-1)*9, 9 +(a-1)*9)
  }
}

df_SNL <- data.frame(Actor = actors, Show = rep("SNL", length(actors)), 
                     BegYear = StartYear , EndYear = LastYear, stringsAsFactors = F)

for (i in 1:nrow(df_SNL)){
        if (df_SNL$EndYear[i] == "") {df_SNL$EndYear[i] <- df_SNL$BegYear[i]}
        else if (df_SNL$EndYear[i] == "pres") {df_SNL$EndYear[i] <- 2016}
}
df_SNL$Actor <- as.factor(df_SNL$Actor)
df_SNL$Show <- as.factor(df_SNL$Show)
df_SNL$BegYear <- as.numeric(df_SNL$BegYear)
df_SNL$EndYear <- as.numeric(df_SNL$EndYear)

DSurl <- "https://en.wikipedia.org/wiki/List_of_The_Daily_Show_correspondents"
tabs_DS <- getURL(DSurl)
tab_DS <- readHTMLTable(tabs_DS)
sub_DS1 <- tab_DS[[2]]
sub_DS2 <- tab_DS[[3]]
sub_DS3 <- tab_DS[[4]]
sub_DS4 <- tab_DS[[5]]
sub_DS5 <- tab_DS[[6]]
DS_actors <- c(as.character(sub_DS1[,1]), as.character(sub_DS2[,1]),
        as.character(sub_DS3[,1]), as.character(sub_DS4[,1]), 
                                     as.character(sub_DS5[,1]))
DS_actors_yearjoin <- c(as.character(sub_DS1[,2]), as.character(sub_DS2[,2]),
               as.character(sub_DS3[,2]), as.character(sub_DS4[,2]), 
               as.character(sub_DS5[,2]))  
## 2016 used for people still on the show to represent date range
DS_actors_yearleft <- c(rep(2016, length(sub_DS1[,2])), rep(2016, length(sub_DS2[,2])),
                        rep(2016, length(sub_DS3[,2])), as.character(sub_DS4[,3]), 
                        as.character(sub_DS5[,3]))  


df_DS <- data.frame(Actor = DS_actors, Show = rep("Daily Show", length(DS_actors)), BegYear = DS_actors_yearjoin, EndYear = DS_actors_yearleft)
## removes people yet to join show
df_DS <- df_DS[df_DS$BegYear != "TBA", ]

df_DS$BegYear <- as.character(df_DS$BegYear)
df_DS$EndYear <- as.character(df_DS$EndYear)
## one just year,so work around
for (a in 1:nrow(df_DS)){
if (nchar(df_DS$BegYear[a]) != 4) {
x <- as.Date(df_DS$BegYear[a], "%B %d, %Y")
df_DS$BegYear[a] <- format(x, "%Y")
}
}

for (a in 1:nrow(df_DS)){
        if (nchar(df_DS$EndYear[a]) != 4) {
                y<- as.Date(df_DS$EndYear[a], "%B %d, %Y")
                df_DS$EndYear[a] <- format(y, "%Y")
        }
} 
df_DS$BegYear <- as.numeric(df_DS$BegYear)
df_DS$EndYear <- as.numeric(df_DS$EndYear)


Actor_df <- rbind(df_SNL, df_DS)

                          
## second pull in movies and tv shows that the actor has appeared in from IMDB
## use this first one to call a search then use id of first name to 
## call the actor (id starts with nm) 

## need to create for loop here:
movie_df <- data.frame(NULL)
## to remove duplicate actor names temp <- Actor_df[Actor_df$Actor == 
count <- 0   
for(a in 1: nrow(Actor_df)) {
split_name <- strsplit(Actor_df$Actor[a], " ")
first_name <- split_name[[1]][1]
last_name <- split_name[[1]][2]
imdb <- "http://www.imdb.com/xml/find?json=1&nr=1&nm=on&q="
actor_searchURL <- paste(imdb, first_name, "+", last_name, sep ="")
result_search <- getURL(actor_searchURL)
results <- fromJSON(result_search)
id <- results[[1]][1]

result_begURL <- "http://www.imdb.com/name/"
result_endURL <- "/?ref_=fn_al_nm_1"

actor_URL <- paste (result_begURL, id, result_endURL, sep = "")
actor_page <- readLines(actor_URL)
r <- grepl("</a></b>", actor_page)
sub <- actor_page[r]
movie_list <- substr(sub, 2, nchar(sub)-8)
for (z in 1:length(movie_list)) {
    count <- count +1
    movie_df[count, 1] <- Actor_df$Actor[a]
    movie_df[count, 2] <- movie_list[z]
}
}


## third pull in Rotten tomatoe review (people not critics) for each movie. 



## prepare cleaner data set with actor, mean of ratings, meadian of ratings, sd of ratings, and max 

for (d in 1:length(Actor_df$Actor)) {
Actor_df[d, 5] <- mean(Movie_df$Score[Movie_df$Actor == Actor_df$Actor[d],])
Actor_df[d,6] <- median(Movie_df$Score[Movie_df$Actor == Actor_df$Actor[d],])
Actor_df[d,7] <- max(Movie_df$Score[Movie_df$Actor == Actor_df$Actor[d],])
Actor_df[d,8] <- sd(Movie_df$Score[Movie_df$Actor == Actor_df$Actor[d],])
}

names(Actor_df) <- c("Actor", "BegYear", "EndYear", "Show", "Mean", "Med", "Max", "SD")


