bigfoot_data <- read.csv("bigfoot_data_wordcount_filtered_less_200.csv")

library(wordcloud)
library(tm)
library(memoise)
library(tidyverse)
library(stringr)
library(ggplot2)




function(input, output) {
  output$WordCloud <- renderPlot({
    
      removed_words <- c("like", "the", "also", "didnt", "there", "got", "this", "just", "didnt")

      kept_words <- sapply( 1:nrow(bigfoot_data),
                            function(n) {
                              words <- str_split(bigfoot_data$observed[n], "\\s")[[1]]
                              words <- tolower(words)
                              words <- gsub(".", "", words, fixed = TRUE)
                              paste( words[ !words %in% removed_words], collapse = " ")
                            })
  #This code created list of words that will show up on the wordcloud
    
  
    wordcloud(kept_words, 
              colors = brewer.pal(8, "Dark2"),
              max.words = input$max_words
              )
  }, height = 600)
 
  
  
  
   output$selectedPlot <- renderPlot({
    if(input$plotChoice == "Sightings by Season") {
      source("Sightings-per-season-bar.R")
      season_bar
    } else if(input$plotChoice == "Sightings by State") {
      source("sightings-per-state.R")
      state_bar
    } else if(input$plotChoice == "Sightings by Temperature") {
      source("sightings-by-temp.R")
    }
  })
}
#this code generates the wordcloud



# AQI MAP
output$aqi_map <- renderLeaflet({
  # Read the data
  aqi_data <- read.csv("AQI_clean_2021(Sheet1) (1).csv")
  
  # Clean and summarize the data
  aqi_summary <- aqi_data %>%
    group_by(State.Name, County.Name, Latitude, Longitude) %>%
    summarise(
      avg_AQI = round(mean(AQI, na.rm = TRUE), 1),
      most_common_category = names(sort(table(Category), decreasing = TRUE))[1],
      n_observations = n(),
      .groups = 'drop'
    ) %>%
    arrange(State.Name, County.Name)
  
  # Save to new CSV
  write.csv(aqi_summary, "AQI_summary_by_county.csv", row.names = FALSE)
  
  # Read in cleaned summary data
  air_data <- aqi_summary
  
  # Add color column to data
  air_data <- air_data %>%
    mutate(color = case_when(
      avg_AQI <= 50 ~ "#BFF2ED",      # Light blue - Good
      avg_AQI <= 100 ~ "#86B8E7",     # Medium blue - Moderate
      avg_AQI <= 150 ~ "#7B60BD",     # Dark blue - Unhealthy for Sensitive Groups
      avg_AQI <= 200 ~ "#CB5FA6",     # Red - Unhealthy
      avg_AQI <= 300 ~ "#E39DB0",     # Purple - Very Unhealthy
      TRUE ~ "#f7dfd5"                # Maroon - Hazardous
    ))
  
  # Create the interactive map
  leaflet(data = air_data) %>%
    addProviderTiles("CartoDB.Positron") %>%
    addCircleMarkers(
      ~Longitude, ~Latitude,
      radius = 6,
      color = ~color,
      stroke = TRUE,
      weight = 1,
      fillOpacity = 0.8,
      popup = ~paste0(
        "<b>", County.Name, ", ", State.Name, "</b><br>",
        "Average AQI: ", avg_AQI, "<br>",
        "Most Common Category: ", most_common_category, "<br>",
        "Number of Observations: ", n_observations
      ),
      label = ~paste0(County.Name, ", ", State.Name, " - AQI: ", avg_AQI),
      labelOptions = labelOptions(
        direction = "auto", 
        style = list("font-size" = "12px", "font-weight" = "bold")
      )
    ) %>%
    addLegend(
      position = "bottomright",
      colors = c("#BFF2ED", "#86B8E7", "#7B60BD", "#CB5FA6", "#E39DB0", "#f7dfd5"),
      labels = c(
        "Good (0-50)", 
        "Moderate (51-100)", 
        "Unhealthy for Sensitive Groups (101-150)",
        "Unhealthy (151-200)", 
        "Very Unhealthy (201-300)",
        "Hazardous (300+)"
      ),
      title = "Air Quality Index",
      opacity = 0.8
    )
})


# BIGFOOT MAP
output$bigfoot_map <- renderLeaflet({
  # Read the CSV file
  df <- read.csv('bigfoot_data.csv')
  
  # Find columns with 'lat' or 'lon'/'lng' in their names (case-insensitive)
  lat_cols <- grep('lat', names(df), ignore.case = TRUE, value = TRUE)
  lon_cols <- grep('lon|lng', names(df), ignore.case = TRUE, value = TRUE)
  
  # Find county column (case-insensitive)
  county_col <- grep('county', names(df), ignore.case = TRUE, value = TRUE)
  
  # Combine the columns to keep
  columns_to_keep <- c(lat_cols, lon_cols, county_col)
  
  # Filter the dataframe
  df_filtered <- df[, columns_to_keep]
  
  # Remove rows with any NA values
  df_filtered <- na.omit(df_filtered)
  
  # Remove specific problematic rows (invalid coordinates)
  if (length(lat_cols) > 0 && length(lon_cols) > 0) {
    df_filtered <- df_filtered[!(df_filtered[, lat_cols[1]] == 46.19614 & df_filtered[, lon_cols[1]] == -141.006), ]
    df_filtered <- df_filtered[!(df_filtered[, lat_cols[1]] == 46.19328 & df_filtered[, lon_cols[1]] == -167.131), ]
    df_filtered <- df_filtered[!(df_filtered[, lat_cols[1]] == 47.57549 & df_filtered[, lon_cols[1]] == -144.0265), ]
  }
  
  # Save to a new CSV file
  write.csv(df_filtered, 'filtered_bigfoot_data_with_county.csv', row.names = FALSE)
  
  # Read the filtered CSV file
  df <- df_filtered
  
  # Create interactive map
  leaflet(df) %>%
    # Add base map tiles
    addTiles() %>%
    # Set initial view to center of US
    setView(lng = -98.5795, lat = 39.8283, zoom = 4) %>%
    # Add markers for each sighting
    addCircleMarkers(
      lng = ~longitude,
      lat = ~latitude,
      radius = 5,
      color = "navy",
      fillColor = "blue",
      fillOpacity = 0.6,
      stroke = TRUE,
      weight = 1,
      popup = ~paste("Latitude:", latitude, "<br>Longitude:", longitude, "<br>County:", county)
    )
})

 # End of server function