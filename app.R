#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(shiny)
options(shiny.sanitize.errors = TRUE)

# Run the application
shiny::shinyApp(ui = ui, server = server)