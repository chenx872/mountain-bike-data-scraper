
load("~/Documents/Egnyte/Private/nlangholz/mountain-bike-data-scraper/data/raw-ews-data/stage-list.Rdata")
load("~/Documents/Egnyte/Private/nlangholz/mountain-bike-data-scraper/data/raw-ews-data/divisions.Rdata")


library(tidyverse)
library(magrittr)

load("~/Documents/Egnyte/Private/nlangholz/mountain-bike-data-scraper/data/raw-ews-data/ews-races.Rdata")

races <- races[ ,-c(5,6)]
races[15,] <- c('2015 Enduro World Series round 1 at Rotorua','2015 Enduro World Series','Rotorua','28th March 2015')
races[27,] <- c('2016 Enduro World Series round 6 at Whistler, BC','2016 Enduro World Series','Whistler, BC','14th August 2016')
races[41,] <- c('2018 Enduro World Series round 6 at Whistler, BC','2018 Enduro World Series','Whistler, BC','12th August 2018')

races %<>% as.data.frame() %>% unnest()
names(races) <- c('race_name','series','city','date')


table(races$series)
table(races$city)


