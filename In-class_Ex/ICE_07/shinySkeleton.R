#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)

# Define UI for application that draws a histogram, ui controls the layout and apperance of the app
ui <- fluidPage()

# Define server logic required to draw a histogram, contains instructions needed to build the app
server <- function(input, output) {}

# Run the application, creates the Shiny app object.
shinyApp(ui = ui, server = server)
