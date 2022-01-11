
htmlLeft <-
  shiny::HTML(
    "<span id='footer-text'>Sentiment on News, David A. Mancilla, &copy; 2021. Based on syuzhet package and NRC EmoLex (saifmohammad.com/WebPages/NRC-Emotion-Lexicon.htm)</span>"
  )

htmlRight <- shiny::HTML(
  "<span id='footer-links'>Find me in:    <a href='https://github.com/dmancilla85' target='_blank'><i class='fab fa-github-alt fa-2x'></i></a>      <a href='https://www.linkedin.com/in/dmancilla1/' target='_blank'><i class='fab fa-linkedin-in fa-2x'></i></a>     <a href='https://www.linkedin.com/in/dmancilla1/' target='_blank'><i class='fab fa-facebook-square fa-2x'></i></a></span>"
)

# Define UI for application that draws a histogram
ui <- dashboardPage(
  skin = "yellow",
  options = list(sidebarExpandOnHover = TRUE),
  header = dashboardHeader(title = "Sentiment on News"),
  sidebar = mySidebarPanel(),
  body = dashboardBody(
    htmltools::tags$head(
      htmltools::tags$link(rel = "icon", href = "favicon.ico"),
      htmltools::tags$link(rel = "preconnect", href = "https://fonts.gstatic.com"),
      htmltools::tags$link(rel = "stylesheet", href = "https://fonts.googleapis.com/css2?family=Merienda&display=swap"),
      htmltools::tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
    ),
    # add_busy_spinner(spin = "breeding-rhombus", margins = c(30, 30), color = "lightblue"),
    # Show a plot of the generated distribution
    fluidRow(
      shinydashboard::box(
        width = 6,
        shinycustomloader::withLoader(plotOutput(outputId = "plt_sentiment"))
      ),
      shinydashboard::box(
        width = 6,
        shinycustomloader::withLoader(plotOutput(outputId = "plt_media"))
      ),
      shinydashboard::box(
        title = "",
        width = 12,
        shinycustomloader::withLoader(DT::dataTableOutput(outputId = "tbl_sentiment"))
      )
    )
  ),
  footer = dashboardFooter(left = htmlLeft, right = htmlRight),
  title = "Sentiment On News"
)
