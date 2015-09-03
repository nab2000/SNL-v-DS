## Getting and Cleaning Data Algorithm
library(RCurl)
library(jsonlite)
library(XML)

## first pull in list of SNL alumni and Daily show alumni, wikepedia

SNLurl <- "https://en.wikipedia.org/wiki/Saturday_Night_Live_cast_members"
tabs_SNL <- getURL(SNLurl)
tab_SNL <- readHTMLTable(tabs)
sub_SNL <- tab[[2]]
snl_actors <- as.character(sub[,1])
snl_actors_years <- as.character(sub[,2])

df_snl <- data.frame(Actor = snl_actor, Show = rep("SNL", length(snl_actors)), Years = snl_actors_years)
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
DS_actors_left <- c(rep("Present", length(sub_DS1[,2])), rep("Present", length(sub_DS2[,2])),
                        rep("present", length(sub_DS3[,2])), as.character(sub_DS4[,3]), 
                        as.character(sub_DS5[,3]))  
        
## second pull in movies and tv shows that the actor has appeared in from IMDB
## use this first one to call a search then use id of first name to 
## call the actor (id starts with nm) 

## need to create for loop here:

split_name <- strsplit(name, " ")
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

## json call http://www.imdb.com/xml/find?json=1&nr=1&nm=on&q=jeniffer+garner
##xml call http://www.imdb.com/xml/find?xml=1&nr=1&tt=on&q=lost

## third pull in Rotten tomatoe review (people not critics) for each movie. 


## prepare this as name of actor, SNL or DS, name of movie/tv show, rating


## prepare cleaner data set with actor, mean of ratins, meadian of ratings, sd of ratins, and max 
## this data set will be used do analysis 
