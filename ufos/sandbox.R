library(shiny)
library(shinydashboard)
library(ggplot2)
library(tidyverse)
library(sentimentr)
library(googleVis)




ufos %>%
  filter(., shape != "") %>%
  group_by(shape) %>%
  summarise(Count=n()) %>%
  mutate(., percentage = Count/sum(Count)) %>%
  top_n(., 20) %>%
  ggplot(data = ., aes(x = shape, y = percentage)) + coord_flip() + geom_bar(stat = "identity")


#produce graph for shape over time
ufos %>%
  group_by(.,year, shape) %>%
  summarise(.,Count = n()) %>%
  mutate(., percentage = Count/sum(Count)) %>%
  filter(., shape == "cone") %>%
  ggplot(data = ., aes( x = year, y = percentage)) + geom_point() + geom_smooth()

#improve graph for shape over time
ufos %>%
  group_by(.,year, shape) %>%
  summarise(.,Count = n()) %>%
  mutate(., percentage = Count/sum(Count)) %>%
  filter(., shape == "cone") %>%
  ggplot(data = ., aes( x = year, y = percentage)) + geom_smooth() + 
  ggtitle("Relative Frequency of UFO Shape Over years") + ylab("Percentage of UFO Shape") +
  xlab("Year") + xlim(1949, 2014) + ylim(0,.35)

#clean data to remove infrequent shapes
top_20_shapes <- ufos %>%
  filter(., shape != "") %>%
  group_by(shape) %>%
  summarise(Count=n()) %>%
  mutate(., percentage = Count/sum(Count)) %>%
  top_n(., 20) %>%
  pull(., shape)

ufos %>%
  filter(., shape %in% top_20_shapes)

#pull out month and year from data
ufos %>%
  mutate(., month = as.Date(datetime, "%m/%d/%y")) %>%
  mutate(., month = as.numeric(format(month, "%m")))

#example to roduce graph number of encounters through out the year
ufos %>%
  filter(., year == 2010) %>%
  group_by(month) %>%
  summarise(Count = n()) %>%
  ggplot(data = ., aes( x = month, y = Count)) + geom_bar(stat = "identity")

#example to improve graph number of encounters through out the year
ufos %>%
  filter(., year == 2010) %>%
  group_by(month) %>%
  summarise(Count = n()) %>%
  mutate(month = as.character(month)) %>%
  ggplot(data = ., aes( x = month, y = Count)) + geom_bar(stat = "identity", fill = "red") +
  ggtitle("Frequency of Sightings by Month") + ylab("Number of Sightings") +
  xlab("Month") 

#improve visualization of number of encounters througout the year, problem can't get before
#1970
library(lubridate)
ufos%>%
  filter(., year == 2010) %>%
  group_by(., year, datetime) %>%
  summarize(., Encounters = n()) %>%
  mutate(., date = parse_date_time(datetime, orders = c("mdy"))) %>%
  select(., date, Encounters) %>%
  calendarPlot(., pollutant = "Encounters", year = 2010, cols = c("red", "green", "blue"),
               main = "Frequency of Sightings")

#improvement on time of year sighting
ufos %>%
  filter(., year == 1990) %>%
  mutate(., duration.seconds = as.numeric(duration.seconds)) %>%
  group_by(., year, datetime) %>%
  summarise(., sum_of_encounters = sum(duration.seconds)/60) %>%
  mutate(., date = parse_date_time(datetime, orders = c("mdy"))) %>%
  select(., date, sum_of_encounters) %>%
  calendarPlot(., pollutant = "sum_of_encounters", year = 1990, cols = c("red", "blue", "yellow"),
               main = "Frequency of Sightings")
  


#map attempt 2
ufos %>%
  filter(., year == 1910) %>%
  group_by(.,month) %>%
  summarise(., Count = n()) %>%
  ggplot(data = ., aes( x = month, y = Count)) + geom_bar(stat = "identity", fill = "red") + xlim(0,13) +
  ggtitle("Frequency of Sightings by Month") + ylab("Number of Sightings") +
  xlab("Month")

#map attempt 3
usa <- map_data("usa")
g<- ggplot() + geom_polygon(data = usa, aes(x=long, y = lat, group = group)) + 
  coord_fixed(1.3) + xlab("Longitude") + ylab("Latitude") + ggtitle("Geographic Distribution of UFO")

g + ufos %>% filter(., year == 2010, shape == "cone") %>% geom_point(
  data = .,
  aes(x = longitude, y = latitude),
  color = "red",
  alpha = 0.25
)

canada<-map_data("Alaska")

#map variant
ufos%>%
  filter(., year == 1925) %>%
  ggplot(data = .) +
  geom_point(aes(x = longitude, y = latitude), color = "red", alpha = 0.25)

#duration of encounter bar chart
ufos %>%
  mutate(duration.seconds = as.numeric(duration.seconds)) %>%
  group_by(., year) %>%
  summarise(., average_duration = mean(duration.seconds)/60) %>%
  filter(., average_duration != is.na(average_duration)) %>%
  ggplot(data = ., aes(x = year, y = average_duration)) + geom_point() + ylim(0,100) +
  ggtitle("Average Encounter Duration") + ylab("Time in Minutes") +
  xlab("Year") +geom_smooth()

#find instantaenous average
ufos %>%
  mutate(duration.seconds = as.numeric(duration.seconds)) %>%
  group_by(., year) %>%
  summarise(., average_duration = mean(duration.seconds)/60) %>%
  filter(., average_duration != is.na(average_duration)) %>%
  filter(., year == 2012)


# make a top ten list of most sightings 
ufos %>%
  mutate(., duration.seconds = as.numeric(duration.seconds)) %>%
  group_by(., datetime) %>%
  summarise(., sum_of_encounters = sum(duration.seconds)/60/60/24) %>%
  mutate(., date = parse_date_time(datetime, orders = c("mdy"))) %>%
  select(., date, sum_of_encounters) %>%
  arrange(., desc(sum_of_encounters)) %>%
  top_n(., 10)


#calendar plot of encounters normalized to 1
ufos %>%
  filter(., year == 1990) %>%
  mutate(., duration.seconds = as.numeric(duration.seconds)) %>%
  group_by(., year) %>%
  summarise(., datetime, fraction = duration.seconds/sum(duration.seconds)) %>%
  mutate(., date = parse_date_time(datetime, orders = c("mdy"))) %>%
  select(., date, fraction) %>%
  calendarPlot(., pollutant = "fraction", year = 1990,
               main = "Frequency of Sightings")

#
  






 



