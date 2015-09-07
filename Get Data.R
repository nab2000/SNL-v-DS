## Getting and Cleaning Data Algorithm
library(RCurl)
library(jsonlite)
library(XML)

## first pull in list of SNL alumni and Daily show alumni, wikepedia

SNLurl <- "https://en.wikipedia.org/wiki/Saturday_Night_Live_cast_members"
tabs_SNL <- getURL(SNLurl)
tab_SNL <- readHTMLTable(tabs_SNL)
sub_SNL <- tab_SNL[[2]]
SNL_actors <- as.character(sub_SNL[,1])
## modifying year formats, may need for loop for 
SNL_actors_years <- as.character(sub_SNL[,2])
StartYear <- data.frame(NULL)
LastYear <- data.frame(NULL)

count <- 0
for(i in 1:length(SNL_actors_years) {
  n <- nchar(SNL_actors[i])/9
  rows <- i+n-1
  
  for(a in 1:n){
  count <- count +1
  actors[count] <- SNL_actors[i]
  
  StartYear[count] <- substr(SNL_actors_years[i], 1 + (a-1)*9, 4+(a-1)*9)

LastYear[count] <- substr(SNL_actors_years[i], 6 +(a-1)*9, 9 +(a-1)*9)
  }


df_SNL <- data.frame(Actor = actors, Show = rep("SNL", length(snl_actors)), 
                     BegYear = StartYear , EndYear = LastYear)



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
df_DS <- df_DS[df_DS$YearJoin != "TBA", ]

## one just year,so work around
for (a in 1:nrow(df_DS$YearJoin){
if (nchar(df_DS$YearJoin[a] != 4) {
df_DS$YearJoin[a] <- as.Date(df_DS$YearJoin[a], "%B %d, %Y")
df_DS$YearJoin[a] <- format(df_DS$YearJoin[a], "%Y")
}

else { df_DS$YearJoin[a] <- format(df_DS$YearJoin[a], "%Y")
}
}
 
Actor_df <- rbind(df_SNL, df_DS)

                          
## second pull in movies and tv shows that the actor has appeared in from IMDB
## use this first one to call a search then use id of first name to 
## call the actor (id starts with nm) 

## need to create for loop here:
movie_df <- data.frame(NULL)
temp <- Actor_df[Actor_df$Actor == 
    for(a in 1: nrow(Actor_df)) {
split_name <- strsplit(Actor_df$Actor[a], " ")
first_name <- split_name[[1]][1]
last_name <- split_name[[1]][2]
imdb <- "http://www.imdb.com/xml/find?json=1&nr=1&nm=on&q="
actor_searchURL <- paste(imdb, first_name, "+", last_name, sep ="")
result_search <- getURL(actor_searchURL)

## need ot figure otu how to pull first id (nm... and remvoe backspace)
id <- 

result_begURL <- "http://www.imdb.com/name/"
result_endURL <- "/?ref_=fn_al_nm_1"

actor_URL <- paste (result_begURL, id, result_endURL, sep = "")
actor_page <- getURL(actor_URL)

}
## json call http://www.imdb.com/xml/find?json=1&nr=1&nm=on&q=jeniffer+garner
##xml call http://www.imdb.com/xml/find?xml=1&nr=1&tt=on&q=lost

## third pull in Rotten tomatoe review (people not critics) for each movie. 



## prepare cleaner data set with actor, mean of ratings, meadian of ratings, sd of ratings, and max 

for (d in 1:length(Actor_df$Actor)) {
Actor_df[d, 5] <- mean(Movie_df$Score[Movie_df$Actor == Actor_df$Actor[d],]
Actor_df[d,6] <- median(Movie_df$Score[Movie_df$Actor == Actor_df$Actor[d],]
Actor_df[d,7] <- max(Movie_df$Score[Movie_df$Actor == Actor_df$Actor[d],]
Actor_df[d,8] <- sd(Movie_df$Score[Movie_df$Actor == Actor_df$Actor[d],]
}

names(Actor_df) <- c("Actor", "BegYear", "EndYear", "Show", "Mean", "Med", "Max", "SD")


