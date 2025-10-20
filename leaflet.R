
# regular leaflet code:
library(leaflet)

leaflet() %>% 
  setView(lng = -98.5795, lat = 39.8283, zoom = 4) %>% 
  addProviderTiles(providers$CartoDB.Positron)

# this special code will be in the server file: this is for the drop boxes

function(input, output, session)
  
output$myMap <- renderLeaflet({
  leaflet(data) %>%
    addCircles()
})

observeEvent(input$checkBox, {
  
  if (input$checkBox) {
    leafletProxy("myMap", session) %>%
      addCircles(...,
                 layerId = "observations"
                 )
  } else {
    leafletProxy("myMap", session) %>$%
      removeShape(layerId = "observations")
  }
}) 