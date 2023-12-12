packages <- c("shiny", "leaflet", "dplyr", "ggplot2", "sf", "tidyverse")

new_packages <- packages[!(packages %in% installed.packages()[,"Package"])]
if(length(new_packages)) install.packages(new_packages)

lapply(packages, library, character.only = TRUE)

library(shiny)
library(leaflet)

source("R/global_statistics.R")
source("R/type_ev_repartition.R")
source("R/number_ev_district.R")
source("R/count_surface_district.R")
source("R/street_type_repartition.R")
source("R/bar_chart_opening_renovation.R")
source("R/map_generation.R")
source("R/histogram_surfaces.R")

data <- read.csv2('assets/datasets.csv')
statistics <- get_statistics(data)


ui <- fluidPage(

    includeCSS("www/bootstrap.css"),
    # Application title
    titlePanel("Paris : espaces verts et assimilés"),

    # Main panel
    fluidRow(
      column(width = 12,

      div(class="stat-boxes",
            div(class = "col stat-box box-red",
                span(class = "stat-box-title", "Nombre total d'espaces verts"),
                   span(class = "stat-box-content", statistics[1])
                ),
          div(class = "col stat-box box-orange",
                span(class = "stat-box-title", "Nouveaux espaces verts en 2023"),
                   span(class = "stat-box-content", statistics[4])
                ),
          div(class = "col stat-box box-green",
                span(class = "stat-box-title", "Surface totale des EV"),
                   span(class = "stat-box-content", paste(format(statistics[2], big.mark = ","), "m²"))
                ),
          div(class = "col stat-box box-purple",
                span(class = "stat-box-title", "Surface horticole totale"),
                   span(class = "stat-box-content", paste(format(statistics[3], big.mark = ","), "m²"))
                ),
      ),
    tags$h3("Répartition des types d'espaces verts"),
      plotOutput("pie_chart_type_ev", width = "100%"),

      tags$h3("Répartition en nombre des espaces verts par arrondissement"),
      plotOutput("bubble_chart_number_ev_district", width = '100%'),
      tags$h3("Répartition par surface des espaces verts par arrondissement"),
      plotOutput("bubble_chart_surface_ev_district", width = '100%'),
      tags$h3("Histogramme : Répartition par intervalle de surface"),
      plotOutput("histo_surfaces", width = '100%'),
      tags$h3("Répartition par surface des espaces verts par type de voie"),
      plotOutput("histo_street_type", width = '100%'),
      tags$h3("Espaces verts ouverts et / ou rénovés par année"),

      sidebarLayout(
        sidebarPanel(
          selectInput("typeData", "Sélectionner le type de données", choices = c("Tous", "Ouvertures", "Rénovations"), selected = "Tous"),
          selectInput("minYear", "Afficher les données à partir de : ",
                  choices = sort(unique(data$annee_ouverture[data$annee_ouverture != 9999])),
                  selected = NULL)
        ),
        mainPanel(
          plotOutput("bar_chart_year_opening_renovation", width = "100%")
        )
      ),




      tags$h3("Localisation des espaces verts parisiens"),
      leafletOutput("map")
      )
    )
)

server <- function(input, output) {

    output$pie_chart_type_ev <- renderPlot({
        create_type_ev_pie_chart(data)
    })

    output$bubble_chart_number_ev_district <- renderPlot({
        create_bubble_charts_count_arrondissement(data)
    })

    output$bubble_chart_surface_ev_district <- renderPlot({
        create_scatter_surfaces(data)
    })

   output$histo_surfaces <- renderPlot({
        create_histogram_surfaces(data)
    })

    output$histo_street_type <- renderPlot({
        create_histogram_street_type(data)
    })

    output$heatmap_correlation <- renderPlot({
        create_heatmpap(data)
    })

    filtered_data <- reactive({
    df_filtered <- data
    if (!is.null(input$typeData) && input$typeData != "Tous") {
      if (input$typeData == "Ouvertures") {
        df_filtered <- df_filtered[!is.na(df_filtered$annee_ouverture), ]
      } else {
        df_filtered <- df_filtered[!is.na(df_filtered$annee_renovation), ]
      }
    }
    if (!is.null(input$minYear)) {
      df_filtered <- df_filtered[df_filtered$annee_ouverture >= input$minYear |
                                  df_filtered$annee_renovation >= input$minYear, ]
    }
    return(df_filtered)
  })

  output$bar_chart_year_opening_renovation <- renderPlot({
    type_data <- switch(input$typeData,
                        "Ouvertures" = 2,
                        "Rénovations" = 3,
                        1)

        fig <- create_bar_chart_year_open(filtered_data(), type_data = type_data)


    print(fig)
  })

  output$map <- renderLeaflet({
      create_map()
  })


}

shinyApp(ui = ui, server = server)

