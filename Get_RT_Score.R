## Pulls in Rotten tomatoe review (audience not critics) for each movie. 
add_RTscores <- function(dir = "./", save_name = "movie_list_RT", load_file = "Movie_List.csv", 
                         load_vector = "movie_df"){

    require(RCurl)
    require(XML)
    
    
    file_loc <- paste(dir, load_file, sep ="")
    
    if (exists(load_vector)){
        movie_df <- get(load_vector)
        
    }else if (file.exists(file_loc)){
        movie_df <- read.csv(file_loc, check.names = F)
        
    }else { print("file does not exist"); stop }
    
    ## clean up movie dataframe to remove SNL and daily show movies/tv shows
    movie_df[,1] <- as.character(movie_df[,1])
    movie_df[,2] <- as.character(movie_df[,2])
    movie_df[,3] <- as.character(movie_df[,3])
    sub <- grep("SNL", movie_df[,3])
    if(length(sub) != 0){movie_df <- movie_df[-sub, ]}
    sub <- grep("Saturday Night Live", movie_df[,3])
    if(length(sub) != 0){movie_df <- movie_df[-sub, ]}
    sub <- grep("Daily Show", movie_df[,3])
    if(length(sub) != 0){movie_df <- movie_df[-sub, ]}
    
    movie_score_df <- data.frame(NULL)
    for (i in 1:nrow(movie_df)){
        vals <- movie_df[i, 2] 
        if (vals == "TV"){
                show_type = "t"
                } else{show_type = "m"}
        rt <- "http://www.rottentomatoes.com/search/?search="
        search <- gsub(" ", "+", movie_df[i, 3])
        search <- gsub(":", "", search)
        search <- gsub("Â", "", search)
        search <- gsub("'", "", search)
        search <- gsub(",", "", search)
        search <- gsub("-", "", search)
        movie_searchURL <- paste(rt, search, sep ="")
        result_search <- getURL(movie_searchURL)
        if (result_search  == "") {
            rt <- "http://www.rottentomatoes.com/"
            movie_title <- gsub(" ", "_", movie_df[i, 3])
            movie_title <- gsub(":", "", movie_title)
            movie_title <- gsub("Â", "", movie_title)
            movie_title <- gsub("'", "", movie_title)
            movie_title <- gsub("II", "2", movie_title)
            movie_title <- gsub("I", "1", movie_title)
            movie_title <- gsub("III", "3", movie_title)
            movie_title <- gsub("IV", "4", movie_title)
            movie_title <- gsub("V", "5", movie_title)
            movie_title <- gsub(",", "", movie_title)
            movie_title <- gsub("-", "", movie_title)
            movie_title <- gsub("!", "", movie_title)
            movie_nameURL <- paste(rt, show_type, "/", movie_title, sep ="")
            movie_page <- getURL(movie_nameURL)
           if (movie_page == ""){next}
            movie_page_html <- htmlTreeParse(movie_page)
            movie_root <- xmlRoot(movie_page_html)
            movie_list <- xmlToList(movie_root)
            movie_head <- movie_list$head
            movie_body <- movie_list$body
            if (length(movie_body[[14]]) == 0) {next}
            if (length(movie_head) < 39) {next}
            if (length(movie_head[[39]]) < 2) {next}
            score <- movie_head[[39]][2] 
            score_num <- as.numeric(substr(score, 1,2))
            if (is.na(score_num)) {next}
           if (length(grep("liked it" , score)) == 0) {next}
            
            movie_score_df[i, 1] <- movie_df[i, 1]
            movie_score_df[i, 2] <- movie_df[i, 2]
            movie_score_df[i, 3] <- movie_df[i, 3]
            movie_score_df[i, 4] <- score_num
            movie_score_df[i, 5] <- movie_nameURL
            }else {
            result <- htmlTreeParse(result_search)
            result_root <- xmlRoot(result)
            result_list <- xmlToList(result_root)
            result_body <- result_list$body
            ## this skips any 
            if (length(result_body[[14]]) < 3) {next}
            if (length(result_body[[14]][[3]]) < 1) {next}
            if (length(result_body[[14]][[3]][[1]]) < 3) {next}
            if (length(result_body[[14]][[3]][[1]][[3]]) < 3) {next}
            if (length(result_body[[14]][[3]][[1]][[3]][[3]]) < 2) {next}
            if (length(result_body[[14]][[3]][[1]][[3]][[3]][[2]]) < 6) {next}
            if (length(result_body[[14]][[3]][[1]][[3]][[3]][[2]][[6]]) < 4) {next}
            ## this next line pulls in the location of the first movie 
            ##to match the search criteria
            title <- result_body[[14]][[3]][[1]][[3]][[3]][[2]][[6]]
            if (is.na(title[4])) {next}
            rt <- "http://www.rottentomatoes.com"
            
            movie_nameURL <- paste(rt, title[4], sep ="")
            movie_page <- getURL(movie_nameURL)
            movie_page_html <- htmlTreeParse(movie_page)
            movie_root <- xmlRoot(movie_page_html)
            movie_list <- xmlToList(movie_root)
            movie_head <- movie_list$head
            if (length(movie_head) < 39) {next}
            if (length(movie_head[[39]]) < 2) {next}
            score <- movie_head[[39]][2] 
            score_num <- as.numeric(substr(score, 1,2))
            if (is.na(score_num)) {next}
            if(length(grep("liked it" , score)) == 1){
                    movie_score_df[i, 1] <- movie_df[i, 1]
                    movie_score_df[i, 2] <- movie_df[i, 2]
                    movie_score_df[i, 3] <- movie_df[i, 3]
                    movie_score_df[i, 4] <- score_num
                    movie_score_df[i, 5] <- movie_nameURL
            } else {next}
            
        }
    }
    names(movie_score_df) <- c("Actor", "Category", "Movie", "Audience_Score", "URL")
    movie_score_df <- movie_score_df[!is.na(movie_score_df$Audience_Score, ]
    movie_score_df$Actor <- as.factor(movie_score_df$Actor)
    movie_score_df$Category <- as.factor(movie_score_df$Category)
    save_loc <- paste(dir, save_name, ".csv", sep = "")
    write.csv(movie_score_df, save_loc, row.names = F)
    movie_score_df <<- movie_score_df
}