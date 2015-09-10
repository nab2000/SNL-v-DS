## third pull in Rotten tomatoe review (people not critics) for each movie. 
add_RTscores <- function(dir = "./", save_name = "Movie_List_RT", load_file = "Movie_List.csv", 
                         load_vector = "movie_df"){

library(RCurl)
library(XML)


file_loc <- paste(dir, load_file, sep ="")
if (exists(load_vector)){
    movie_df <- get(load_vector)
    
}
else if (file.exists(file_loc)){
    movie_df <- read.csv(file_loc, check.names = F)
    
}

else { print("file does not exist"); stop }

for (i in 1:nrow(movie_df)){
    rt <- "http://www.rottentomatoes.com/search/?search="
    search <- gsub(" ", "+", movie_df[i, 2])
    search <- gsub(":", "", search)
    movie_searchURL <- paste(rt, search, sep ="")
    result_search <- getURL(movie_searchURL)
    result <- htmlTreeParse(result_search)
    result_root <- xmlRoot(result)
    result_list <- xmlToList(result_root)
    result_body <- result_list$body
    ## this next line pulls in the location of the first movie to match the search criteria
    title <- result_body[[14]][[3]][[1]][[3]][[3]][[2]][[6]]
    
    result_search <- readLines(movie_searchURL)
    rt <- "http://www.rottentomatoes.com"
    movie_nameURL <- paste(rt, title[4], sep ="")
    movie <- readLines(movie_nameURL)
    
    ## for read lines of movie title sub <- result_search[278]
    ## for finding score for audience
    </span>% 
    
}
}