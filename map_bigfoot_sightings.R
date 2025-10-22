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

# Save to a new CSV file
write.csv(df_filtered, 'filtered_bigfoot_data_with_county.csv', row.names = FALSE)

# Print information
cat("Original columns:", names(df), "\n")
cat("Kept columns:", columns_to_keep, "\n")
cat("Dimensions:", dim(df_filtered), "\n")


# Install packages if needed (run once)
# install.packages("leaflet")

# Load library
library(leaflet)

# Read the CSV file
df <- read.csv('filtered_bigfoot_data_with_county.csv')

# Create interactive map
map <- leaflet(df) %>%
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
    popup = ~paste("Latitude:", latitude, "<br>Longitude:", longitude , "<br>County:" , county)
  )

# Display the map
map

# Optional: Save as HTML file
library(htmlwidgets)
saveWidget(map, "bigfoot_interactive_map.html", selfcontained = TRUE)