library(ggplot2)
library(ggcorrplot)

create_heatmpap <- function(data) {

  numeric_data <- data[, sapply(data, is.numeric)]
  correlation_matrix <- round(cor(numeric_data), 2)

  print(correlation_matrix)
  return(ggcorrplot(correlation_matrix))
}
