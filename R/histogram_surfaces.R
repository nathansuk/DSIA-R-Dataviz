library(ggplot2)

create_histogram_surfaces <- function(data) {
  intervalles <- c(0, 100, 1000, 10000, 100000, Inf)

  # Créer une nouvelle colonne 'Surface Interval' avec les intervalles définis
  data$`intervalles de surfaces` <- cut(data$surface_totale_reelle, breaks = intervalles, labels = FALSE)

  # Calcule les fréquences des intervalles
  counts <- table(data$`intervalles de surfaces`)

  interval_labels <- c("0-100", "100-1000", "1000-10000", "10000-100000", "100000+")
  plot_data <- data.frame(interval = factor(interval_labels, levels = interval_labels), count = as.numeric(counts))

    plot <- ggplot(plot_data, aes(x = interval, y = count)) +
    geom_bar(stat = "identity", fill = 'green') +
    labs(x = "Intervalle de Surface (m²)", y = "Nombre d'espaces verts") +
    theme_minimal() +
    theme(axis.title = element_text(size = 14))

  return(plot)
}