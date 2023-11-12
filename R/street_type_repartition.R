library(ggplot2)
library(dplyr, warn.conflicts = FALSE)

create_histogram_street_type <- function(data) {
  df <- data

  # Filtrage des types de voie mal renseignés
  df$adresse_typevoie <- gsub("^\\s+|\\s+$", "", df$adresse_typevoie) # Suppression des espaces au début et à la fin
  df$adresse_typevoie <- sapply(strsplit(df$adresse_typevoie, " "), function(x) x[1])

  # Supprimer les ligne avec 'ND'
  df <- df[df$adresse_typevoie != 'ND', ]

  # Remplacer les ligne avec 'rue' à la place de 'RUE'
  df$adresse_typevoie <- gsub('rue', 'RUE', df$adresse_typevoie)

  # Supprimer les ligne avec 'NA'
  df <- df[df$adresse_typevoie != 'NA', ]

  # Compter les occurrences pour chaque type de voie
  street_type_counts <- df %>%
    group_by(adresse_typevoie) %>%
    summarise(Count = n()) %>%
    arrange(Count)

  histogram <- ggplot(street_type_counts, aes(x = Count, y = reorder(adresse_typevoie, Count), fill = adresse_typevoie)) +
    geom_bar(stat = 'identity') +
    labs(x = 'Nombre d\'Espaces Verts', y = 'Type de Voie') +
    theme_minimal() +
    theme(axis.text = element_text(size = 13),
          axis.title = element_text(size = 14))

  return(histogram)
}

