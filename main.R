library(shiny)
library(leaflet)

source("R/type_ev_repartition.R")
source("R/number_ev_district.R")
source("R/count_surface_district.R")
source("R/street_type_repartition.R")
source("R/bar_chart_opening_renovation.R")
source("R/map_generation.R")

data <- read.csv2('assets/datasets.csv')

ui <- fluidPage(

    # Application title
    titlePanel("Paris : espaces verts et assimilés"),

    # Main panel
    mainPanel(

      plotOutput("pie_chart_type_ev", width = "100%"),
      plotOutput("bubble_chart_number_ev_district", width = '100%'),
      plotOutput("bubble_chart_surface_ev_district", width = '100%'),
      plotOutput("histo_street_type", width = '100%'),
      sidebarLayout(
        sidebarPanel(
          selectInput("typeData", "Sélectionner le type de données", choices = c("Tous", "Ouvertures", "Rénovations"), selected = "Tous"),
          selectInput("minYear", "Année minimale",
                  choices = sort(unique(data$annee_ouverture[data$annee_ouverture != 9999])),
                  selected = NULL)
        ),
        mainPanel(
          plotOutput("bar_chart_year_opening_renovation", width = "100%")
        )
      ),
      leafletOutput("map")

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


    print(fig)  # La fonction ggplot doit être imprimée pour être affichée dans Shiny
  })

  output$map <- renderLeaflet({
      create_map()
  })


}

shinyApp(ui = ui, server = server)

