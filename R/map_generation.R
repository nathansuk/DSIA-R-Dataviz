library(leaflet)
library(sf)

create_map <- function() {

  print("GENERATION DE LA MAP EN COURS")

  geojson_file <- "assets/espaces_verts.geojson"
  data <- st_read(geojson_file)

  map <- leaflet() %>%
    addTiles() %>%
    setView(lng = 2.3522, lat = 48.8566, zoom = 12)

  for (i in seq_along(data$geometry)) {
      map <- addPolygons(map, data = data[i, ])
  }

  return(map)


}
