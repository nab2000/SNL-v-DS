movie_list <- function(dir = "./", file_name = "Movie_List", load_vector = "Actor_df", load_file = "Actor_List.csv"){

library(RCurl)
library(jsonlite)
library(xml2)
library(XML)

## second pull in movies and tv shows that the actor has appeared in from IMDB
## use this first one to call a search then use id of first name to 
## call the actor (id starts with nm) 

    file_loc <- paste(dir, load_file, sep ="")
if (exists(load_vector)){
    Actor_df <- get(load_vector)

}
    else if (file.exists(file_loc)){
        Actor_df <- read.csv(file_loc, check.names = F)
        
    }
    
    else { print("file does not exist"); stop }
    

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
    id <- results[[1]][1,1]
    
    result_begURL <- "http://www.imdb.com/name/"
    result_endURL <- "/?ref_=fn_al_nm_1"
    
    actor_URL <- paste (result_begURL, id, result_endURL, sep = "")
    actor_page <- readLines(actor_URL)
    r <- grepl("</a></b>", actor_page)
    if (length(r[r == "TRUE"]) == 0){next}
    
    sub <- actor_page[r]
    movie_list <- substr(sub, 2, nchar(sub)-8)
    for (z in 1:length(movie_list)) {
        count <- count +1
        movie_df[count, 1] <- Actor_df$Actor[a]
        movie_df[count, 2] <- movie_list[z]
    }
}

movie_df[,1] <- as.factor(movie_df[,1])

save_loc <- paste(dir, file_name, ".csv", sep="")
write.csv(movie_df, save_loc, row.names = F) 
movie_df <<- movie_df

}