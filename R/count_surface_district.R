library(ggplot2)
library(dplyr, warn.conflicts = FALSE)

create_scatter_surfaces <- function(data) {
  # Suppression des codes postaux inférieurs ou égaux à 76000
  data_filtered <- data %>%
    filter(adresse_codepostal <= 76000)

  # Somme des surfaces totales cumulées / arrondissement
  surface_par_arrondissement <- data_filtered %>%
    group_by(adresse_codepostal) %>%
    summarise(surface_totale_reelle = sum(surface_totale_reelle, na.rm = TRUE))

  scatter_plot <- ggplot(surface_par_arrondissement, aes(x = as.factor(adresse_codepostal), y = surface_totale_reelle)) +
    geom_bar(stat = "identity") +
    scale_fill_gradient(low = "blue", high = "red") +
    labs(x = "Code Postal", y = "Surfaces totales réelles cumulées (m²)") +
    scale_size_continuous(range = c(5, 15)) +
    theme_minimal() +
        theme(axis.text = element_text(size = 13),
          axis.title = element_text(size = 14)) +
    scale_x_discrete(limits = unique(as.factor(surface_par_arrondissement$adresse_codepostal)))

  return(scatter_plot)
}