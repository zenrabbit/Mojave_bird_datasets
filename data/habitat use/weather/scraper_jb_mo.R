#Scraper for weather station

### Granite Mountains Weather Station  
#Data posted directly to the [web](https://wrcc.dri.edu/cgi-bin/rawMAIN.pl?caucgr). 


library(httr)
library(rvest)
library(tidyverse)

#need to query site because it dynamically populates table based on form inputs
#we can simulate this n R (bryce mecum rules)

#fill in year
year <- "19"

#fill in month
month <- "08"

#need to input last day of the month 1:last day or range of interest
days <- seq(1:30)

data <- data.frame()
for (i in days){
req <- POST("https://wrcc.dri.edu/cgi-bin/wea_daysum2.pl", 
            body = list(
              stn = "UCGR",
              mon = month,
              day = i,
              yea = year,
              unit = "E",
              type = "reg"
            ))
page <- content(req)
tables <- html_nodes(page, "table")
table <- html_table(tables[[1]], fill = TRUE)
table <- table[,-c(3,7, 9, 11, 13, 16, 18, 20:24)]
colnames(table) <- table[1:4,] %>% gsub("[[:punct:]]|c", "",.)
table <- table[-c(1:4, 29:45),]
table$day <- i
table$month <- month
table$year <- year
data <- rbind(data, table)
}

write.csv(data, "~/Masters/Desert-Bird-Habitat-Use/weather/august_weather.csv",row.names=TRUE)

april <- read.csv('~/Masters/Desert-Bird-Habitat-Use/weather/april_weather.csv')
may <- read.csv('~/Masters/Desert-Bird-Habitat-Use/weather/may_weather.csv')
june <- read.csv('~/Masters/Desert-Bird-Habitat-Use/weather/june_weather.csv')
august <- read.csv('~/Masters/Desert-Bird-Habitat-Use/weather/august_weather.csv')

library(dplyr)

weather <- bind_rows(april, may)
weather <- bind_rows(weather, june)
weather <- bind_rows(weather, august)

write.csv(weather, "~/Masters/Desert-Bird-Habitat-Use/weather/weather.csv", row.names=TRUE)
