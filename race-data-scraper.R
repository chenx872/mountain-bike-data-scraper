
library(rvest)

url <- 'https://www.rootsandrain.com/race5977/'
#Reading the HTML code from the website
webpage <- read_html(url)


race_name_dirty <- html_nodes(webpage,'#h1-title')
race_name_data <- html_text(race_name_dirty)
race_name_data
race_name_dirty <- html_nodes(webpage,'h1 a')
race_name_data <- html_text(race_name_dirty)
race_name_data

organizer_dirty <- html_nodes(webpage,'p a')
organizer_data <- html_text(organizer_dirty)[3]
organizer_data

date_dirty <- html_nodes(webpage,'time')
date_data <- html_text(date_dirty)
date_data

stage_children = 1:20

stages <- NULL
for(i in 1:length(stage_children)){
  stage_data_dirty <- html_nodes(webpage, paste0('td:nth-child(',stage_children[i],')'))
  stage_data <- html_text(stage_data_dirty)
  stages <- cbind(stages,stage_data)
}


stage_data_dirty <- html_nodes(webpage, paste0('th:nth-child(',stage_children[i],')'))
stage_data <- html_text(stage_data_dirty)
stage_data

date_dirty <- html_nodes(webpage,'th')
date_data <- html_text(date_dirty)
date_data

table(date_data)

length(date_data)/6
date_data[1:15]

date_dirty <- html_nodes(webpage,'div h2')
date_data <- html_text(date_dirty)
date_data
