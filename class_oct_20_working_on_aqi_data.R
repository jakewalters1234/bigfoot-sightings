library(dplyr)
aqi_data <- read.csv("AQI_clean_2021(Sheet1) (1).csv")
print(colnames(aqi_data))

# Install dplyr if you haven't already (run this once)
# install.packages("dplyr")

# Load required library
library(dplyr)

# Read the data (adjust file path as needed)
aqi_data <- read.csv("AQI_clean_2021(Sheet1) (1).csv")

# Check column names to make sure they're correct
print("Column names in your data:")
print(colnames(aqi_data))

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

# View the first few rows
head(aqi_summary)

# Save to new CSV
write.csv(aqi_summary, "AQI_summary_by_county.csv", row.names = FALSE)

# Print summary statistics
cat("Total counties:", nrow(aqi_summary), "\n")
cat("Data saved to: AQI_summary_by_county.csv\n")

# 1️⃣ Install required packages (run once if not already installed)
# install.packages(c("leaflet", "dplyr"))

# 2️⃣ Load packages
library(leaflet)
library(dplyr)

# 3️⃣ Read in your cleaned summary data
# Option A: If you saved the CSV from the previous script
air_data <- read.csv("AQI_summary_by_county.csv")

# Option B: Or use the aqi_summary object if it's still in your environment
# air_data <- aqi_summary

# 4️⃣ Create color palette function based on AQI values
getColor <- function(aqi) {
  case_when(
    aqi <= 50 ~ "#BFF2ED",      # Light blue - Good
    aqi <= 100 ~ "#86B8E7",     # Medium blue - Moderate
    aqi <= 150 ~  "#7B60BD",     # Dark bLue - Unhealthy for Sensitive Groups
    aqi <= 200 ~ "#CB5FA6",     # Red - Unhealthy
    aqi <= 300 ~ "#E39DB0",     # Purple - Very Unhealthy
    TRUE ~ "#f7dfd5"            # Maroon - Hazardous
  )
}

# 5️⃣ Add color column to data
air_data <- air_data %>%
  mutate(color = getColor(avg_AQI))

# 6️⃣ Create the interactive map
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
    colors = c("#BFF2ED","#86B8E7", "#7B60BD", "#CB5FA6", "#E39DB0", "#f7dfd5" ),
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