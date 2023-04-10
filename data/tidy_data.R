library(readr)
library(janitor)

duke_forest_raw <- read_csv("duke_forest.csv", show_col_types = FALSE)

# Remove the type, hoa, and url columns because they contain the same value for all the observations
duke_forest_clean <- select(duke_forest_raw, -type, -hoa, -url) 

# Split the address column into separate columns because it contains multiple variables
duke_forest_clean <- separate(duke_forest_clean, address, into = c("area", "city", "state"), sep = ",")

# Remove the city and state columns because they contain the same value for all the observations
duke_forest_clean <- select(duke_forest_clean, -city, -state)

# Split the area column into separate columns because it contains multiple variables
duke_forest_clean <- separate(duke_forest_clean, area, into = c("number", "street", "type"), sep = " ")

# Remove the type column because it contains the same value for all the observations
duke_forest_clean <- select(duke_forest_clean, -type)

# Beginning of dealing with heating column

# Split the heating column by comma to create a list of heating types for each observation
duke_forest_clean$heating <- strsplit(as.character(duke_forest_clean$heating), ", ")

# Get a unique list of all heating types in the dataset
heating_types <- unique(unlist(duke_forest_clean$heating))

# Create a new column for each unique heating type with initial value "no"
for (heating_type in heating_types) {
  duke_forest_clean[[heating_type]] <- "no"
}

# Loop through each row of the data set and put "yes" for each heating type exists in that observation
for (i in 1:nrow(duke_forest_clean)) {
  for (heating_type in duke_forest_clean$heating[[i]]) {
    duke_forest_clean[i, heating_type] <- "yes"
  }
}

# Remove the heating column
duke_forest_clean <- select(duke_forest_clean, -heating)

# Remove blanks from column names
duke_forest_clean <- clean_names(duke_forest_clean)

# Remove the no_data, radiant, wood_pellet, baseboard columns because they contain the same value for all the observations
duke_forest_clean <- select(duke_forest_clean, -no_data, -radiant, -wood_pellet, -baseboard)

# Add "heating_" to the names of the columns related to the heating
duke_forest_clean <- duke_forest_clean %>%
  rename(
    heating_other = other,
    heating_gas = gas,
    heating_forced_air = forced_air,
    heating_heat_pump = heat_pump,
    heating_electric = electric
  )

# End of dealing with heating column

# Beginning of dealing with parking column

# Split the parking column by comma to create a list of parking types for each observation
duke_forest_clean$parking <- strsplit(as.character(duke_forest_clean$parking), ", ")

# Get a unique list of all parking types in the data set
parking_types <- unique(unlist(duke_forest_clean$parking))

# Create a new column for each unique parking type with initial value "no"
for (parking_type in parking_types) {
  duke_forest_clean[[parking_type]] <- "no"
}

# Loop through each row of the dataframe and check if each parking type exists in that observation
for (i in 1:nrow(duke_forest_clean)) {
  for (parking_type in duke_forest_clean$parking[[i]]) {
    duke_forest_clean[i, parking_type] <- "yes"
  }
}

# Remove the parking column
duke_forest_clean <- select(duke_forest_clean, -parking)

# Remove blanks from column names
duke_forest_clean <- clean_names(duke_forest_clean)

# Remove the column x0-spaces because it is a redundant info
duke_forest_clean <- select(duke_forest_clean, -x0_spaces)

# Add "parking_" to the names of the columns related to the parking
duke_forest_clean <- duke_forest_clean %>%
  rename(
    parking_carport = carport,
    parking_covered = covered,
    parking_garage_attached = garage_attached,
    parking_garage_detached = garage_detached,
    parking_off_street = off_street,
    parking_on_street = on_street,
    parking_garage = garage
  )

# End of dealing with parking column

# Remove rows with NA values
duke_forest_clean <- drop_na(duke_forest_clean)

# Save the updated data set as a new csv file
 write.csv(duke_forest_clean, "duke_forest_tidy.csv", row.names=FALSE)

# Print the new data set
print(glimpse(duke_forest_clean))








