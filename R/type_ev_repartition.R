library(ggplot2)

create_type_ev_pie_chart <- function(data) {

  type_ev_counts <- table(data$type_ev)

  pie_chart <- ggplot(data = data, aes(x = "", fill = type_ev)) +
    geom_bar(width = 1, position = "fill") +
    coord_polar(theta = "y") +
    labs(fill = "Type d'Espace Vert") +
    theme_minimal() +
    theme(axis.text = element_text(size = 13),
          axis.title = element_text(size = 14)) +
    theme(legend.position = "right")

  return(pie_chart)
}