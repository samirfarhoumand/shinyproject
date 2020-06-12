library(shiny)
library(shinydashboard)
library(ggplot2)
library(tidyverse)
library(DT)
library(ggmap)
library(rworldmap)
library(lubridate)
library(openair)


ufos <- read.csv("./cleaned_scrubbed.csv") 

#vector of top twenty two shapes 
top_22_shapes <- ufos %>%
  filter(., shape != "") %>%
  group_by(shape) %>%
  summarise(Count=n()) %>%
  mutate(., percentage = Count/sum(Count)) %>%
  top_n(., 22) %>%
  pull(., shape) %>%
  toupper(.)

#clean data to add a column of months
ufos <- ufos %>%
  mutate(., month = as.Date(datetime, "%m/%d/%y")) %>%
  mutate(., month = as.numeric(format(month, "%m"))) %>%
  arrange(., year)

#produce a map of US
usa <- map_data("usa")
g <-
  ggplot() + geom_polygon(data = usa, aes(x = long, y = lat, group = group)) +
  coord_fixed(1.3) + xlab("Longitude") + ylab("Latitude") + ggtitle("Geographic Distribution of UFO Sightings")









