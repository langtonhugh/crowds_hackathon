
library(dplyr)
library(tmaptools)

gl_2018_pitch_df <- read_csv("data/retrosheet_gl_2018.csv")
crimes_df <- read_csv("data/us_crime_2018.csv")

gl_2018_pitch_df <- gl_2018_pitch_df %>% 
  mutate(name = if_else(name ==  "Guaranteed Rate Field;U.S. Cellular Field",
                        "Guaranteed Rate Field",
                        name),
         name = if_else(name == "AT&T Park",
                        "Oracle Park",
                        name))

gl_2018_pitch_df <- gl_2018_pitch_df %>%
  filter(city %in% crimes_df$city_name)

# Create vector of unique stadium names.
stadiums_vec <- unique(gl_2018_pitch_df$name)

# Create empty list for geocoding results.
stads_list <- list()

# For each stadium name, retrieve the xy coorindates from Google Maps.
for (i in stadiums_vec) {
  geocode_result <-  geocode_OSM(i)
  stads_list[[i]] <- geocode_result$coords
}

# Bind results together.
stads_df <- bind_rows(stads_list, .id = "stadium_name")

# save
