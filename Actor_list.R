actor_list <- function(dir = "./", file_name = "Actor_List") {
## Getting and Cleaning Data Algorithm
library(RCurl)
library(jsonlite)
library(xml2)
library(XML)

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
Actor_df$Actor <- as.character(Actor_df$Actor) 

save_loc <- paste(dir, file_name, ".csv", sep ="")
write.csv(Actor_df, save_loc, row.names = F)
Actor_df <<- Actor_df
}