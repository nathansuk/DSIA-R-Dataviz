library(ggplot2)
library(dplyr, warn.conflicts = FALSE)

create_bubble_charts_count_arrondissement <- function(ev_dataframe) {
    data <- ev_dataframe %>%
      group_by(adresse_codepostal) %>%
      summarize(`Nombre d'espaces verts` = n()) %>% # Comptage des espaces verts / code postal
      filter(adresse_codepostal <= 76000) # Suppression des codes postaux > à 76000

    bubble_chart <- ggplot(data, aes(x = adresse_codepostal, y = `Nombre d'espaces verts`, size = `Nombre d'espaces verts`, color = `Nombre d'espaces verts`, label = adresse_codepostal)) +
      geom_point() +
      geom_text(aes(label = `Nombre d'espaces verts`), vjust = 2, size=8) +
      labs(title = "Nombre d'espaces verts par arrondissement", x = "Code postal", y = "Nombre d'espaces verts") +
      scale_size_continuous(range = c(5, 15)) +
      scale_color_continuous(trans = "sqrt") +
      theme_minimal() +
      scale_x_continuous(breaks = unique(as.numeric(data$adresse_codepostal)), labels = unique(data$adresse_codepostal))


    return(bubble_chart)

}