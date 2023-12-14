library(ggplot2)
library(dplyr, warn.conflicts = FALSE)

create_bar_chart_year_open <- function(data, min_year=NULL, type_data=1) {

  # Exclusion des valeurs NA
  data <- data %>% filter(!is.na(annee_ouverture))

  # Exclusion des années = 9999
  data <- data %>% filter(annee_ouverture != 9999)

  # Filtrer par année spécifiée
  if (!is.null(min_year)) {
    if (type_data %in% c(1, 2)) {  # Ajout de cette condition pour ne filtrer que pour les ouvertures
      data <- data %>% filter(annee_ouverture == min_year)
    } else {
      data <- data %>% filter(annee_ouverture >= min_year)
    }
  }

  # Compter par date
  count_by_year <- data %>% count(annee_ouverture)

  # Création d'un dataframe pour les rénovations si nécessaire
  if (type_data %in% c(1, 3)) {
    data_renovation <- data %>% filter(!is.na(annee_renovation))
    count_renovations <- data_renovation %>% count(annee_renovation)
    renovations <- tibble(`Annee` = count_renovations$annee_renovation,
                          `Nombre de renovations` = count_renovations$n,
                          Type = 'Rénovations')
  } else {
    renovations <- tibble(`Annee` = integer(0), `Nombre de renovations` = integer(0), Type = 'Rénovations')
  }

  # Création d'un dataframe combinant ouvertures et rénovations et création du graph
  if (type_data == 1) {
    combined_df <- bind_rows(tibble(`Annee` = count_by_year$annee_ouverture,
                                    `Nombre d'ouvertures` = count_by_year$n,
                                    Type = 'Ouvertures'),
                             renovations)

    fig_both <- ggplot(combined_df, aes(x = factor(`Annee`), y = `Nombre d'ouvertures`)) +
      geom_bar(stat = 'identity', fill = 'blue', color = 'black') +
      geom_bar(data = combined_df %>% filter(Type == 'Rénovations'),
               aes(y = `Nombre de renovations`),
               stat = 'identity', fill = 'red', color = 'black') +
      labs(
        x = "Année",
        y = "Nombre d'ouvertures et rénovations"
      ) +
      theme_minimal() +
      theme(axis.title = element_text(size = 14),
            axis.text.x = element_text(angle = 90, hjust = 1))

    return(fig_both)

  } else if (type_data == 2) {
    combined_df <- tibble(`Annee` = count_by_year$annee_ouverture,
                          `Nombre d'ouvertures` = count_by_year$n,
                          Type = 'Ouvertures')
    fig_ouvertures <- ggplot(combined_df, aes(x = factor(`Annee`), y = `Nombre d'ouvertures`)) +
      geom_bar(stat = 'identity', fill = 'blue', color = 'black') +
      geom_bar(data = combined_df %>% filter(Type == 'Ouvertures'),
               aes(y = `Nombre d'ouvertures`),
               stat = 'identity', fill = 'red', color = 'black') +
      labs(
        x = "Année",
        y = "Nombre d'ouvertures"
      ) +
      theme_minimal() +
      theme(axis.title = element_text(size = 14),
            axis.text.x = element_text(angle = 90, hjust = 1))

    return(fig_ouvertures)

  } else {
    combined_df <- renovations
    fig_renovations <- ggplot(combined_df, aes(x = factor(`Annee`), y = `Nombre de renovations`)) +
      geom_bar(stat = 'identity', fill = 'blue', color = 'black') +
      geom_bar(data = combined_df %>% filter(Type == 'Rénovations'),
               aes(y = `Nombre de renovations`),
               stat = 'identity', fill = 'red', color = 'black') +
      labs(
        x = "Année",
        y = "Nombre de renovations"
      ) +
      theme_minimal() +
      theme(axis.title = element_text(size = 14),
            axis.text.x = element_text(angle = 90, hjust = 1))
    return(fig_renovations)
  }

}
