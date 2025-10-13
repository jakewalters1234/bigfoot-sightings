bfro_reports_geocoded_9_29 <- read.csv("~/bigfoot_data.csv")

library(wordcloud)
library(tm)
library(memoise)

function(input, output) {
  output$WordCloud <- renderPlot({
    wordcloud(bfro_reports_geocoded_9_29$observed)
  })
}


#End of function for word cloud