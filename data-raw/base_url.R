## code to prepare `base_url` dataset goes here

# Taken from https://eerscmap.usgs.gov/uspvdb/
base_url <- "https://eersc.usgs.gov/api/uspvdb/v1/"

usethis::use_data(base_url, internal = TRUE, overwrite = TRUE)
