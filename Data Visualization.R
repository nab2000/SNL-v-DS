Actor_Score <- read.csv("Actor_Score.csv")
library(outliers)
library(ggplot2)
par(mfrow = c(1,2), mar = c(2, 4, 4, 2))
with(Actor_Score[Actor_Score$Show == "SNL",], hist(RT_Mean, breaks = 10))
with(Actor_Score[Actor_Score$Show == "Daily Show",], hist(RT_Mean, breaks =10))

par(mfrow = c(1,1))
with(Actor_Score, plot(Show, RT_Mean))
     
Actor_Score$Years <- Actor_Score$EndYear - Actor_Score$BegYear
sub <- Actor_Score[!outlier(Actor_Score$Years, logical = T), ]
sub <- sub[!outlier(sub$RT_Mean, logical = T), ]
g <- ggplot(aes(x = Years, y = RT_Mean, col = Show), data = sub)
g <- g+ geom_point()
g <-g +  geom_smooth(method = "lm", formula = y~x, se = F)