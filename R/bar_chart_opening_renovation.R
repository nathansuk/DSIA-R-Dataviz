library(ggplot2)
library(dplyr)

create_bar_chart_year_open <- function(data, min_year=NULL, type_data=1) {

  # Exclusion des valeurs NA
  data <- data %>% filter(!is.na(annee_ouverture))

  # Exclusion des années = 9999
  data <- data %>% filter(annee_ouverture != 9999)

  # Supprimer les dates si spécifié
  if (!is.null(min_year)) {
    data <- data %>% filter(annee_ouverture >= min_year)
  }

  # Compter par date
  count_by_year <- data %>% count(annee_ouverture)

  # Création d'un dataframe pour les rénovations si nécessaire
  if (type_data %in% c(1, 3)) {
    data_renovation <- data %>% filter(!is.na(annee_renovation))
    count_renovations <- data_renovation %>% count(annee_renovation)
    renovations <- tibble(Année = count_renovations$annee_renovation,
                          `Nombre de rénovations` = count_renovations$n,
                          Type = 'Rénovations')
  } else {
    renovations <- tibble(Année = integer(0), `Nombre de rénovations` = integer(0), Type = 'Rénovations')
  }

  # Création d'un dataframe combinant ouvertures et rénovations et création du graph
  if (type_data == 1) {
    combined_df <- bind_rows(tibble(Année = count_by_year$annee_ouverture,
                                    `Nombre d'ouvertures` = count_by_year$n,
                                    Type = 'Ouvertures'),
                                    renovations)

  fig_both <- ggplot(combined_df, aes(x = as.factor(Année), y = `Nombre d'ouvertures`)) +
    geom_bar(stat = 'identity', fill = 'blue', color = 'black') +
    geom_bar(data = combined_df %>% filter(Type == 'Rénovations'),
             aes(y = `Nombre de rénovations`),
             stat = 'identity', fill = 'red', color = 'black') +
    labs(title = "Nombre d'espaces verts ouverts et rénovés par année",
         x = "Année",
         y = "Nombre d'ouvertures et rénovations") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))

  return(fig_both)

  }
  # Création d'un dataframe avec les ouvertures uniquement et création du graph
  else if (type_data == 2) {
    combined_df <- tibble(Année = count_by_year$annee_ouverture,
                          `Nombre d'ouvertures` = count_by_year$n,
                          Type = 'Ouvertures')
    fig_ouvertures <- ggplot(combined_df, aes(x = as.factor(Année), y = `Nombre d'ouvertures`)) +
    geom_bar(stat = 'identity', fill = 'blue', color = 'black') +
    geom_bar(data = combined_df %>% filter(Type == 'Ouvertures'),
             aes(y = `Nombre d'ouvertures`),
             stat = 'identity', fill = 'red', color = 'black') +
    labs(title = "Nombre d'espaces verts ouverts et rénovés par année",
         x = "Année",
         y = "Nombre d'ouvertures") +
    theme_minimal()

    return(fig_ouvertures)

  }
  # Création d'un dataframe avec les rénovations uniquement et création du graph
  else {
    combined_df <- renovations
    fig_renovations <- ggplot(combined_df, aes(x = as.factor(Année), y = `Nombre de rénovations`)) +
    geom_bar(stat = 'identity', fill = 'blue', color = 'black') +
    geom_bar(data = combined_df %>% filter(Type == 'Rénovations'),
             aes(y = `Nombre de rénovations`),
             stat = 'identity', fill = 'red', color = 'black') +
    labs(title = "Nombre d'espaces verts ouverts et rénovés par année",
         x = "Année",
         y = "Nombre de rénovations") +
    theme_minimal()
    return(fig_renovations)
  }

}