
load("~/Documents/Egnyte/Private/nlangholz/mountain-bike-data-scraper/data/raw-ews-data/stage-list.Rdata")
load("~/Documents/Egnyte/Private/nlangholz/mountain-bike-data-scraper/data/raw-ews-data/divisions.Rdata")


library(tidyverse)
library(magrittr)

load("~/Documents/Egnyte/Private/nlangholz/mountain-bike-data-scraper/data/raw-ews-data/ews-races.Rdata")

races <- races[ ,-c(6,7)]
races[15,] <- c('2015 Enduro World Series round 1 at Rotorua','2015 Enduro World Series','Rotorua','28th March 2015','2015-03-28')
races[27,] <- c('2016 Enduro World Series round 6 at Whistler, BC','2016 Enduro World Series','Whistler, BC','14th August 2016','2016-08-14')
races[42,] <- c('2018 Enduro World Series round 6 at Whistler, BC','2018 Enduro World Series','Whistler, BC','12th August 2018','2018-08-12')

races %<>% as.data.frame() %>% unnest()
names(races) <- c('race_name','series','city','date','ymd')

table(races$series)
table(races$city)

load("~/Documents/Egnyte/Private/nlangholz/mountain-bike-data-scraper/data/raw-ews-data/ews-series-years.Rdata")
series_list %<>% unlist(series_list,recursive = FALSE)

series_list[[3]]$Competitors[5] <- 0
series_list[[3]]$Competitors <- as.integer(series_list[[3]]$Competitors)

#why doesn't this work?????
#series_list %<>% unlist(series_list,recursive = FALSE)
sl <- bind_rows(series_list[[1]],series_list[[2]])
sl <- bind_rows(sl,series_list[[3]])
sl <- bind_rows(sl,series_list[[4]])
sl <- bind_rows(sl,series_list[[5]])
series_list <- bind_rows(sl,series_list[[6]])

names(series_list) <- c('date','race','venue','competitors','mens_result','womens_result')




