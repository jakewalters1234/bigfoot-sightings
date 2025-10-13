bigfoot_data <- read.csv("bigfoot_data.csv")

library(wordcloud)
library(tm)
library(memoise)

function(input, output) {
  output$WordCloud <- renderPlot({
    wordcloud(bigfoot_data$state)
  })
}


#End of function for word cloud