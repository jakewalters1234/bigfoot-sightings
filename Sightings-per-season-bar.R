library(tidyverse)
library(ggplot2)

bigfoot_data <- read.csv("bigfoot_data.csv")
bigfoot_data %>%
  count(season)

ggplot(bigfoot_data, aes(season)) + geom_bar(fill = "deepskyblue2") + labs(title = "Number of Bigfoot Sightings Per Season") + xlab("Season") + ylab("Sightings")
