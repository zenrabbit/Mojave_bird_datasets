library(tidyverse)

weather <- read_csv("~/Masters/Desert-Bird-Habitat-Use/weather/weather.csv")

data <- read_csv("~/Masters/Desert-Bird-Habitat-Use/data/tidy_data.csv")

table <- left_join(data, weather, by = 'month.day.hour') %>% 
  select(date, Hour, survey, Total.Solar.Rad..ly, X.Wind.Ave.mph, Air.Temperature.Mean.Deg.F, Relative.Humidity.Mean.Perent) 

table <- unique(table, by=survey)

write_csv(table, "~/Masters/Desert-Bird-Habitat-Use/weather/table.csv")
