library(xml2)
library(dplyr)

# Load the full RSS feed
rss <- read_xml("docs/rss.xml")

# Extract items
items <- xml_find_all(rss, "//item")

# Filter items by category
filtered_items <- items %>%
  purrr::keep(function(item) {
    categories <- xml_find_all(item, "category")
    any(xml_text(categories) == "R")
  })

# Create a new RSS feed with the filtered items
rss_filtered <- rss
xml_find_all(rss_filtered, "//item") %>% xml_remove()
for (item in filtered_items) {
  xml_add_child(rss_filtered, item)
}

# Save the filtered RSS feed
write_xml(rss_filtered, "docs/r-rss.xml")
