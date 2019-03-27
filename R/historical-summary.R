library(dplyr)
library(magrittr)
library(ggplot2)

load("~/Documents/Egnyte/Private/nlangholz/mountain-bike-data-scraper/data/final-ews-data/ews-races-complete.Rdata")

series_list %<>% filter(mens_winner != 'cancelled')

mens_race_wins <- series_list %>% group_by(mens_winner) %>% summarise(race_wins = n()) %>% arrange(desc(race_wins))

womens_race_wins <- series_list %>% group_by(womens_winner) %>% summarise(race_wins = n()) %>% arrange(desc(race_wins))


plot(x=seq(1,23,1),y=seq(1,5,5/28),type='n',axes = FALSE,xlab = '',ylab ='',main = 'EWS Race Wins')
points(1:23,rep(4,23),pch = 15, col = 'gold',cex = 2.55)
points(1:15,rep(3.5,15),pch = 15, col = 'gold',cex = 2.55)
points(1:6,rep(3,6),pch = 15, col = 'gold',cex = 2.55)
points(1,rep(2.5,),pch = 15, col = 'gold',cex = 2.55)

max_wins = 10
winners = 4
plot(x=seq(1,max_wins,1),y=seq(1,winners/2,length.out = max_wins),type='n',axes = FALSE,xlab = '',ylab ='',main = 'EWS Race Wins')
points(1:10,rep(2,10),pch = 15, col = 'lightblue',cex = 2.55)
points(1:10,rep(2,10),pch = 15, col = 'lightblue',cex = 2.55)


load("~/Documents/Egnyte/Private/nlangholz/mountain-bike-data-scraper/data/final-ews-data/ews-stages-complete.Rdata")

stage_results %>% group_by(name) %>% mutate(avg_pos = mean(as.numeric(position),na.rm = TRUE),races = n()) %>% arrange(avg_pos)  %>% filter(races > 10) %>% select(name,avg_pos,races) %>% unique() %>% View()
stage_results %>% group_by(name) %>% mutate(avg_pos = mean(as.numeric(position),na.rm = TRUE),races = n()) %>% arrange(avg_pos)  %>% filter(races > 10) %>% select(name,avg_pos,races) %>% unique() %>% View()

stage_results[which(tolower(stage_results$name) =='cécile ravanel'),]



#gsub works
stage_results$stage_1 <- gsub('*s*','',stage_results$stage_1)
#this doesn't
strptime(stage_results$stage_1, format = "%m:%S:%OS")
#this does something, not right yet
strptime("23:57.1",format = "%H:%M.%OS")
