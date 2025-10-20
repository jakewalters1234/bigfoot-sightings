library(shiny)
library(shinythemes)

navbarPage(
   "Select a Page to Explore!", # Title of the navigation bar
  tabPanel(
    "Home Page", 
    fluidPage(
      img(src = "bigfoot.png", width = "600px"),
      h1("Welcome to My App"),
      p("This is the main landing page.")
    )

    
  ), #tabPanel for the main page,
  # Word cloud for the words most used in the bigfoot sighting reports 
  
  tabPanel("WordCloud", 
           fluidPage(
             h2("WordCloud of Words Used to Describe BigFoot Sightings"),
             shinythemes::themeSelector(),
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
               ), 
            
           )#fluidPage
  ),#tabPanel for the word cloud
  
  tabPanel("Visualizations for Bigfoot Sightings",
           fluidPage(
             h3("Multiple Visualizations of Bigfoot Sightings")
           )#fluidpage for visualizations page
    
  )#Tabpanel for visualizations page
  
)#navbarPage





