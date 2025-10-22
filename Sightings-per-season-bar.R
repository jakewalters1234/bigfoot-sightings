library(tidyverse)
library(ggplot2)

bigfoot_data <- read.csv("bigfoot_data.csv")
 bigfoot_data %>%
  count(season)

ggplot(bigfoot_data, aes(season)) + geom_bar(fill = "#0047AB")          + 
  labs(title = "Number of Bigfoot Sightings Per Season")                + 
  xlab("Season") + ylab("Sightings")                                    +
  theme(panel.background = element_rect(fill = "#F0FFFF"), 
        plot.background = element_rect(fill = "#F0FFFF"))

