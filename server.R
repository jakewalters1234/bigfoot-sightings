bigfoot_data <- read.csv("bigfoot_data_wordcount_filtered_less_200.csv")

library(wordcloud)
library(tm)
library(memoise)
library(tidyverse)
library(stringr)




function(input, output) {
  output$WordCloud <- renderPlot({
    
      removed_words <- c("like", "the", "also", "didnt", "there", "got", "this")

      kept_words <- sapply( 1:nrow(bigfoot_data),
                            function(n) {
                              words <- str_split(bigfoot_data$observed[n], "\\s")
                              paste( words[ !words %in% removed_words])
                            })
  
    
    
    wordcloud(kept_words, max.words = 10)
  }, height = 600)
}

