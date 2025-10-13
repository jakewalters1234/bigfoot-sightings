library(shiny)

# Word cloud for the words most used in the bigfoot sighting reports 
fluidPage(
    plotOutput("WordCloud", height = "auto")
)
