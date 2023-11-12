get_statistics <- function(data) {
  statistics <- c(
    nrow(data),                           # Nombre d'espaces verts renseignés
    sum(data$surface_totale_reelle, na.rm = TRUE),      # Somme des surfaces
    sum(data$surface_horticole, na.rm = TRUE),          # Somme des surfaces horticoles
    sum(data$annee_ouverture == 2023, na.rm = TRUE)     # Nombre d'ouvertures en 2023
  )

  return(statistics)
}