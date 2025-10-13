bigfoot_data <- read.csv("bigfoot_data_wordcount_filtered_less_200.csv")

library(wordcloud)
library(tm)
library(memoise)
library(tidyverse)
library(stringr)

function(input, output) {
  output$WordCloud <- renderPlot({
    wordcloud(bigfoot_data$observed)
  })
}


#End of function for word cloud