library(shiny)
library(shinythemes)
library(leaflet)

navbarPage(
  "Select a Page to Explore!",
  
  tabPanel(
    "Home Page", 
    fluidPage(
      div(style = "text-align: center;",
        tags$img(src = "bigfoot-landing-page.jpg", width = "900px"),
        tags$h1("Welcome to Bigfoot Sightings"),
        tags$h2("Have you ever wondered where Bigfoot has been found? 
        Want to know where to look next? Well, you've come to the right place!")), 

      tags$head(
        tags$style(HTML("
      @keyframes slide {
        0% {
          left: -100px;
        }
        100% {
          left: 100%;
        }
      }
      
      #moving-image {
        position: fixed;
        top: 50%;
        left: -100px;
        animation: slide 8s ease-in-out forwards;
        z-index: 9999;
      }
    "))
      ),
      
      tags$audio(src = "growl-and-roar-102417.mp3", 
                 autoplay = "autoplay",
                 type = "audio/mpeg"),
      
      tags$img(id = "moving-image", 
               src = "bigfoot-image.webp",
               width = "300px")
    )
  ),
  
  tabPanel("WordCloud", 
           fluidPage(
             h2("WordCloud of Words Used to Describe BigFoot Sightings"),
             shinythemes::themeSelector(),
             
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
                 plotOutput("WordCloud")
               )
             )
           )
  ),
  
  tabPanel("Visualizations for Bigfoot Sightings",
           fluidPage(
             h3("Multiple Visualizations of Bigfoot Sightings"), 
             selectInput("plotChoice", "Choose a Plot:",
                         choices = c("Sightings by Season", "Sightings by State", "Sightings by Temperature")),
             plotOutput("selectedPlot")
           )
  ),
  
  tabPanel("Maps",
           fluidPage(
             tabsetPanel(
               tabPanel("AQI Map",
                        br(),
                        leafletOutput("aqi_map", height = "600px")
               ),
               tabPanel("Bigfoot Sightings Map",
                        br(),
                        leafletOutput("bigfoot_map", height = "600px")
               )
             )
           )
  )
)