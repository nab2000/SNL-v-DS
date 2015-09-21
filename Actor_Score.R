Actor_Score <- function (dir = "./", save_name = "Actor_Score", 
                     load_movie = "movie_list_RT_Final.csv", load_file = "Actor_List.csv", 
                     load_vector_mv = "movie_df", load_vector = "Actor_df"){
    
    ## check for and load movie data frame 
    file_loc <- paste(dir, load_movie, sep ="")
    
    if (exists(load_vector_mv)){
        movie_df <- get(load_vector_mv)
        
    }
    else if (file.exists(file_loc)){
        movie_df <- read.csv(file_loc, check.names = F)
        
    }
    
    else { print("file does not exist"); stop }
    
    ## check for and load actor data frame 
    file_loc <- paste(dir, load_file, sep ="")
    if (exists(load_vector)){
        Actor_df <- get(load_vector)
        
    }
    else if (file.exists(file_loc)){
        Actor_df <- read.csv(file_loc, check.names = F)
        
    }
    
    else { print("file does not exist"); stop }
    
    Actor_Score <- data.frame(NULL)
    
    for (d in 1:nrow(Actor_df)) {
        sub <- movie_df$Audience_Score[movie_df$Actor == as.character(Actor_df$Actor[d])]
        if(length(sub) == 0) {next}
        Actor_Score[d,1] <- Actor_df$Actor[d]
        Actor_Score[d,2] <- Actor_df$BegYear[d]
        Actor_Score[d,3] <- Actor_df$EndYear[d]
        Actor_Score[d,4] <- Actor_df$Show[d]
        Actor_Score[d,5] <- mean(sub)
        Actor_Score[d,6] <- median(sub)
        Actor_Score[d,7] <- max(sub)
        Actor_Score[d,8] <- sd(sub)
    }
    
    names(Actor_Score) <- c("Actor", "BegYear", "EndYear", "Show", "RT_Mean", "RT_Med", "RT_Max", "RT_SD")
    Actor_Score <- Actor_Score[!is.na(Actor_Score$Actor), ]
    save_loc <- paste(dir, save_name, ".csv", sep = "")
    write.csv(Actor_Score, save_loc, row.names = F)
    Actor_Score <<- Actor_Score
    
}
