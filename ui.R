library(shiny)

# Word cloud for the words most used in the bigfoot sighting reports 
fluidPage(
    plotOutput("WordCloud", height = "auto"),
    
    sidebarLayout(
      sidebarPanel(
        sliderInput("max_words",
                    "Select Amount of Words Shown:",
                    min = 1,
                    max = 100,
                    value = 50,
                    step = 1)
      ),
      
      mainPanel(
        plotOutput("wordcloud")
      )
    )
)



