## Getting and Cleaning Data Algorithm
library("RCurl")
library("jsonlite")


## first pull in list of SNL alumni and Daily show alumni, wikepedia


## second pull in movies and tv shows that the actor has appeared in from IMDB
http://www.imdb.com/xml/find?json=1&nr=1&nm=on&q=jeniffer+garner
http://www.imdb.com/xml/find?xml=1&nr=1&tt=on&q=lost

## third pull in Rotten tomatoe review (people not critics) for each movie. 


## prepare this as name of actor, SNL or DS, name of movie/tv show, rating


## prepare cleaner data set with actor, mean of ratins, meadian of ratings, sd of ratins, and max 
## this data set will be used do analysis 
