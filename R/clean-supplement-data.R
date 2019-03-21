


library(tidyverse)
library(magrittr)

load("~/Documents/Egnyte/Private/nlangholz/mountain-bike-data-scraper/data/raw-ews-data/ews-races.Rdata")

races <- races[ ,-c(6,7)]
races[15,] <- c('2015 Enduro World Series round 1 at Rotorua','2015 Enduro World Series','Rotorua','28th March 2015','2015-03-28')
races[27,] <- c('2016 Enduro World Series round 6 at Whistler, BC','2016 Enduro World Series','Whistler, BC','14th August 2016','2016-08-14')
races[36,] <- c('2017 Enduro World Series round 7 at Whistler, BC','2017 Enduro World Series','Whistler, BC','13th August 2017','2018-08-13')
races[43,] <- c('2018 Enduro World Series round 6 at Whistler, BC','2018 Enduro World Series','Whistler, BC','12th August 2018','2018-08-12')

races %<>% as.data.frame() %>% unnest()
races$race_ids <- c(2017:2023,2091:2097,3029:3032,3034:3036,3921:3925,4093,3927:3928,4480:4487,5977:5981,6880,5983:5984)
names(races) <- c('race_name','series','city','date','ymd','race_id')

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

library(stringr)
#mutate doesn't work because character(0) at position 19
#series_list %<>% mutate(mens_winner = str_extract_all(series_list$mens_result,'(?<=\\().+?(?=\\))') %>% unlist())
#mens winners
mens_winners <- str_extract_all(series_list$mens_result,'(?<=\\().+?(?=\\))') %>% unlist()
mens_winners <- tolower(append(mens_winners,'cancelled',after = 18))
mens_winners[9] <- "nicolas lau"
table(mens_winners)

#womens winners
womens_winners <- str_extract_all(series_list$womens_result,'(?<=\\().+?(?=\\))') %>% unlist()
womens_winners <- tolower(append(womens_winners,'cancelled',after = 18))
womens_winners[43] <- "cécile ravanel"
table(womens_winners)

#countries raced
country <- str_extract_all(series_list$venue,'(?<=\\().+?(?=\\))') %>% unlist()
table(country)

series_list$race <- c(1:7,1:7,1:8,1:8,1:8,1:8)
series_list$race_id <- c(2017:2023,2091:2097,3029:3036,3921:3925,4093,3927:3928,4480:4487,5977:5981,6880,5983:5984)


series_list %<>% mutate(mens_winner = mens_winners, womens_winner = womens_winners, country = country)

races %<>% full_join(series_list,by = 'race_id')

table(races$mens_winner)

save(series_list, file ='data/final-ews-data/ews-races-complete.Rdata')


load("~/Documents/Egnyte/Private/nlangholz/mountain-bike-data-scraper/data/raw-ews-data/divisions.Rdata")
divisions <- lapply(divisions,function(x) str_squish(str_remove(as.character(x$division_data)," show_chart View race progression dialpad View finish spread")))


load("~/Documents/Egnyte/Private/nlangholz/mountain-bike-data-scraper/data/raw-ews-data/stage-list.Rdata")

stage_results <- bind_rows(stage_list)
riders_num <- unlist(lapply(stage_list,function(x) dim(x)[1]))
race_ids <- c(2017:2023,2091:2097,3029:3032,3034:3036,3921:3925,4093,3927:3928,4480:4487,5977:5981,6880,5983:5984)
race_ids <- rep(race_ids,times = riders_num)
stage_results$race_id <- race_ids

x1 <- diff(c(which(stage_results$`Pos ▼`==1),dim(stage_results)[1]))
x1[length(x1)] <- x1[length(x1)] + 1

rep_divisions <- rep(unlist(divisions),times = x1)

stage_results$division = rep_divisions
stage_results <- stage_results[,(names(stage_results)!="")]

stage_results$`Stage 1`[is.na(stage_results$`S1 - G-F...`)==FALSE] <- as.character(stage_results$`S1 - G-F...`[is.na(stage_results$`S1 - G-F...`)==FALSE])
stage_results$`Stage 2`[is.na(stage_results$`S2 - Jaw...`)==FALSE] <- as.character(stage_results$`S2 - Jaw...`[is.na(stage_results$`S2 - Jaw...`)==FALSE])
stage_results$`Stage 3`[is.na(stage_results$`S3 - Tot...`)==FALSE] <- as.character(stage_results$`S3 - Tot...`[is.na(stage_results$`S3 - Tot...`)==FALSE])
stage_results$`Stage 4`[is.na(stage_results$`S4 - Inn...`)==FALSE] <- as.character(stage_results$`S4 - Inn...`[is.na(stage_results$`S4 - Inn...`)==FALSE])
stage_results$`Stage 5`[is.na(stage_results$`S5 - Mas...`)==FALSE] <- as.character(stage_results$`S5 - Mas...`[is.na(stage_results$`S5 - Mas...`)==FALSE])
stage_results$`Stage 6`[is.na(stage_results$`S6 - Rev...`)==FALSE] <- as.character(stage_results$`S6 - Rev...`[is.na(stage_results$`S6 - Rev...`)==FALSE])
stage_results$`Stage 7`[is.na(stage_results$`S7 - Sti...`)==FALSE] <- as.character(stage_results$`S7 - Sti...`[is.na(stage_results$`S7 - Sti...`)==FALSE])
stage_results$`Stage 8`[is.na(stage_results$`S8 - Lan...`)==FALSE] <- as.character(stage_results$`S8 - Lan...`[is.na(stage_results$`S8 - Lan...`)==FALSE])

stage_results %<>% select(-`S1 - G-F...`,-`S2 - Jaw...`,-`S3 - Tot...`,-`S4 - Inn...`,-`S5 - Mas...`,-`S6 - Rev...`,-`S7 - Sti...`,-`S8 - Lan...`)

stage_results$`Stage 1`[is.na(stage_results$Saturday)==FALSE] <- as.character(stage_results$Saturday[is.na(stage_results$Saturday)==FALSE])
stage_results$`Stage 2`[is.na(stage_results$Sunday)==FALSE] <- as.character(stage_results$Sunday[is.na(stage_results$Sunday)==FALSE])

stage_results %<>% select(-Saturday,-Sunday)

stage_results$`Stage 1`[is.na(stage_results$`Micro Cl...`)==FALSE] <- as.character(stage_results$`Micro Cl...`[is.na(stage_results$`Micro Cl...`)==FALSE])
stage_results$`Stage 2`[is.na(stage_results$`Crazy Tr...`)==FALSE] <- as.character(stage_results$`Crazy Tr...`[is.na(stage_results$`Crazy Tr...`)==FALSE])
stage_results$`Stage 3`[is.na(stage_results$`Delayed ...`)==FALSE] <- as.character(stage_results$`Delayed ...`[is.na(stage_results$`Delayed ...`)==FALSE])
stage_results$`Stage 4`[is.na(stage_results$`Heavy Fl...`)==FALSE] <- as.character(stage_results$`Heavy Fl...`[is.na(stage_results$`Heavy Fl...`)==FALSE])
stage_results$`Stage 5`[is.na(stage_results$`Top Of T...`)==FALSE] <- as.character(stage_results$`Top Of T...`[is.na(stage_results$`Top Of T...`)==FALSE])
stage_results$`Stage 2`[is.na(stage_results$`Too Tight`)==FALSE] <- as.character(stage_results$`Too Tight`[is.na(stage_results$`Too Tight`)==FALSE])

stage_results %<>% select(-`Micro Cl...`,-`Crazy Tr...`,-`Delayed ...`,-`Heavy Fl...`,-`Top Of T...`,-`Too Tight`)

stage_results$`Stage 1`[is.na(stage_results$Marin)==FALSE] <- as.character(stage_results$Marin[is.na(stage_results$Marin)==FALSE])
stage_results$`Stage 2`[is.na(stage_results$Haglofs)==FALSE] <- as.character(stage_results$Haglofs[is.na(stage_results$Haglofs)==FALSE])
stage_results$`Stage 3`[is.na(stage_results$Napier)==FALSE] <- as.character(stage_results$Napier[is.na(stage_results$Napier)==FALSE])
stage_results$`Stage 4`[is.na(stage_results$WTB)==FALSE] <- as.character(stage_results$WTB[is.na(stage_results$WTB)==FALSE])
stage_results$`Stage 5`[is.na(stage_results$Enve)==FALSE] <- as.character(stage_results$Enve[is.na(stage_results$Enve)==FALSE])
stage_results$`Stage 6`[is.na(stage_results$Hope)==FALSE] <- as.character(stage_results$Hope[is.na(stage_results$Hope)==FALSE])

stage_results %<>% select(-Marin,-Haglofs,-Napier,-WTB,-Enve,-Hope)

names(stage_results) <- c('position','bib','name','area','yob','sponsors'
                          ,'stage_1','stage_2','stage_3','stage_4','stage_5','total_time','diff'
                          ,'licence','penalties','stage_6','stage_7','stage_8','stage_9','race_id','division')


stage_results <- stage_results[c('position','bib','name','area','yob','licence','sponsors'
  ,'stage_1','stage_2','stage_3','stage_4','stage_5','stage_6','stage_7','stage_8','stage_9'
  ,'total_time','diff','division','race_id')]

save(stage_results, file ='data/final-ews-data/ews-stages-complete.Rdata')




