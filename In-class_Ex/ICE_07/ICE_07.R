#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)

pacman::p_load(sf, spdep, tmap, bslib, tidyverse)
hunan <- st_read(dsn = "data/geospatial", layer = "Hunan")
data <- read_csv("data/aspatial/Hunan_2012.csv")
hunan_data <- left_join(hunan, data, by = c("County" = "County"))

# Define UI for application that draws a histogram, ui controls the layout and appearance of the app
ui <- fluidPage(titlePanel("Title: Choropleth Mapping"),
                sidebarLayout(
                  sidebarPanel(
                    selectInput(
                      inputId = "variable",
                      label = "Mapping variable",
                      choices = list(
                        "Gross Domestic Product, GDP" = "GDP",
                        "Gross Domestic Product Per Capita" = "GDPPC",
                        "Gross Industry Output" = "GIO",
                        "Output Value of Agriculture" = "OVA",
                        "Output Value of Service" = "OVS"
                      ),
                      selected = "GDPPC"
                    ),
                    selectInput(
                      inputId = "classification",
                      label = "Classification method:",
                      choices = list(
                        "sd" = "sd",
                        "equal" = "equal",
                        "pretty" = "pretty",
                        "quantile" = "quantile",
                        "kmeans" = "kmeans",
                        "hclust" = "hclust",
                        "bclust" = "bclust",
                        "fisher" = "fisher",
                        "jenks" = "jenks"
                      ),
                      selected = "pretty"
                    ),
                    sliderInput(
                      inputId = "classes",
                      label = "Number of classes",
                      min = 5,
                      max = 10,
                      value = c(6)
                    ),
                    selectInput(
                      inputId = "colour",
                      label = "Colour scheme:",
                      choices = list(
                        "blues" = "Blues",
                        "reds" = "Reds",
                        "greens" = "Greens",
                        "Yellow-Orange-Red" = "YlOrRd",
                        "Yellow-Orange-Brown" = "YlOrBr",
                        "Yellow-Green" = "YlGn",
                        "Orange-Red" = "OrRd"
                      ),
                      selected = "YlOrRd"
                    ),
                    sliderInput(
                      inputId = "opacity",
                      label = "Level of Transparency",
                      min = 0,
                      max = 1,
                      value = c(0.5)
                    ),
                  ),
                  mainPanel(
                    tmapOutput("mapPlot", 
                               width = "100%", 
                               height = 580)
                  )
                  #, position = "right" # if you want the sidebar panel to be on the right hand side
                ))

# Define server logic required to draw a histogram, contains instructions needed to build the app
server <- function(input, output) {
  output$mapPlot <- renderTmap({
    tmap_options(check.and.fix = TRUE) +
      tm_shape(hunan_data) +
      tm_fill(
        input$variable,
        n = input$classes,
        style = input$classification,
        palette = input$colour,
        alpha = input$opacity) +
      tm_borders(lwd = 0.1, alpha = 1) +
      tm_view(set.zoom.limits = c(6.5, 8))
  })
}

# Run the application, creates the Shiny app object.
shinyApp(ui = ui, server = server)