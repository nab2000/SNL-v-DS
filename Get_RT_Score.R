## Pulls in Rotten tomatoe review (audience not critics) for each movie. 
add_RTscores <- function(dir = "./", save_name = "movie_list_RT", load_file = "Movie_List.csv", 
                         load_vector = "movie_df"){

require(RCurl)
require(XML)


file_loc <- paste(dir, load_file, sep ="")

if (exists(load_vector)){
    movie_df <- get(load_vector)
    
}
else if (file.exists(file_loc)){
    movie_df <- read.csv(file_loc, check.names = F)
    
}

else { print("file does not exist"); stop }

## clean up movie dataframe to remove SNL and daily show movies/tv shows
movie_df[,1] <- as.character(movie_df[,1])
movie_df[,2] <- as.character(movie_df[,2])
sub <- grep("SNL", movie_df[,2])
movie_df <- movie_df[-sub, ]
sub <- grep("Saturday Night Live", movie_df[,2])
movie_df <- movie_df[-sub, ]
sub <- grep("Daily Show", movie_df[,2])
movie_df <- movie_df[-sub, ]

movie_score_df <- NULL
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
    ## this skips any 
    if (length(result_body1[[14]][[3]][[1]]) == 13) {next}
    ## this next line pulls in the location of the first movie to match the search criteria
    title <- result_body[[14]][[3]][[1]][[3]][[3]][[2]][[6]]
    
    rt <- "http://www.rottentomatoes.com"
    movie_nameURL <- paste(rt, title[4], sep ="")
    movie_page <- getURL(movie_nameURL)
    movie_page_html <- htmlTreeParse(movie_page)
    movie_root <- xmlRoot(movie_page_html)
    movie_list <- xmlToList(movie_root)
    movie_head <- movie_list$head
    score <- movie-head[[42]][2] 
    score_num <- as.numeric(substr(score, 1,2))
    if (is.na(score_num)) {next}
    
    movie_score_df[i, 1] <- movie_df[i, 1]
    movie_score_df[i, 2] <- movie_df[i, 2]
    movie_score_df[i, 3] <- score_num
    movie_score_df[i, 4] <- movie_nameURL
    names(movie_score_df) <- c("Actor", "Movie", "Audience_Score", "URL")

    save_loc <- paste(dir, save_name, ".csv", sep = "")
    write.csv(movie_score_df, save_loc, row.names = F)
    movie_score_df <<- movie_score_df

    
}
}