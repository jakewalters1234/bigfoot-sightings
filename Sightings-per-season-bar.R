library(tidyverse)
library(ggplot2)

bigfoot_data <- read.csv("bigfoot_data.csv")
 bigfoot_data %>%
  count(season)

season_bar <- ggplot(bigfoot_data, aes(season)) + geom_bar(fill = "darkblue") +
  labs(title = "Number of Bigfoot Sightings Per Season") + xlab("Season") + ylab("Sightings") +
  theme(axis.text = element_text(size = 14),
        axis.title = element_text(size = 16))
      


