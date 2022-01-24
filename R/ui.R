
# Define UI for application that draws a histogram
ui <- dashboardPage(
  skin = "yellow",
  options = list(sidebarExpandOnHover = TRUE),
  header = dashboardHeader(title = "Sentiment on News"),
  sidebar = showSidebar(i18n),
  body = dashboardBody(
    htmltools::tags$head(
      htmltools::tags$link(rel = "icon", href = "favicon.ico"),
      htmltools::tags$link(rel = "preconnect", href = "https://fonts.gstatic.com"),
      htmltools::tags$link(rel = "stylesheet", href = "https://fonts.googleapis.com/css2?family=Merienda&display=swap"),
      htmltools::tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
    ),
    # Tooltips
    shinyBS::bsTooltip("sel_language", "Language of the news",
      "right",
      options = list(container = "body", animation = "true")
    ),
    shinyBS::bsTooltip("chk_latest_news",
      "Breaking news or news up to 3 days old?",
      "right",
      options = list(container = "body", animation = "true")
    ),
    shinyBS::bsTooltip("sel_country", "Select the country of origin of the news",
      "right",
      options = list(container = "body", animation = "true")
    ),
    shinyBS::bsTooltip("sel_category", "Filter by news categories",
      "right",
      options = list(container = "body", animation = "true")
    ),
    shinyBS::bsTooltip("chk_search_titles", "Look for articles with the keyword in the titles",
      "right",
      options = list(container = "body", animation = "true")
    ),
    shinyBS::bsTooltip("btn_start", "Click to start sentiment analysis on news",
      "right",
      options = list(container = "body", animation = "true")
    ),
    shinyBS::bsTooltip("txt_caption", "Enter the keyword to search",
      "right",
      options = list(container = "body", animation = "true")
    ),
    # Show a plot of the generated distribution
    fluidRow(
      shinydashboard::box(
        width = 5,
        shinycustomloader::withLoader(plotOutput(outputId = "plt_emotion"))
      ),
      shinydashboard::box(
        width = 3,
        shinycustomloader::withLoader(plotOutput(outputId = "plt_sentiment"))
      ),
      shinydashboard::box(
        width = 4,
        shinycustomloader::withLoader(plotOutput(outputId = "plt_media"))
      ),
      shinydashboard::box(
        title = "",
        width = 12,
        shinycustomloader::withLoader(DT::dataTableOutput(outputId = "tbl_sentiment"))
      )
    )
  ),
  footer = shinydashboardPlus::dashboardFooter(left = footerModule$htmlLeft, right = footerModule$htmlRight),
  title = "Sentiment On News"
)
