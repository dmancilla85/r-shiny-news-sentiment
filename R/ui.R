# Options
# spinners <- c("dnaspin","pacman")
spinner_type <- "dnaspin"

# Define UI for application that draws a histogram
ui <- dashboardPage(
  skin = "yellow",
  options = list(sidebarExpandOnHover = TRUE),
  header = dashboardHeader(title = "Sentiment on News"),
  sidebar = showSidebar(i18n),
  body = dashboardBody(
    htmltools::tags$head(
      htmltools::tags$link(rel = "icon", href = "favicon.ico"),
      htmltools::tags$link(
        rel = "preconnect",
        href = "https://fonts.gstatic.com"
      ),
      htmltools::tags$link(
        rel = "stylesheet",
        href = "https://fonts.googleapis.com/css2?family=Merienda&display=swap"
      ),
      htmltools::tags$link(
        rel = "stylesheet",
        type = "text/css", href = "custom.css"
      ),
      htmltools::tags$meta(
        name = "description",
        content = "App to analize emotion and sentiment on news content, using the NRC EmoLex."
      )
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
      # row 1
      shinydashboard::box(
        title = "Bag of Positive Sentiments",
        width = 6,
        background = "orange",
        shinycustomloader::withLoader(
          loader = spinner_type,
          wordcloud2::wordcloud2Output(outputId = "plt_bag_positive")
        )
      ),
      shinydashboard::box(
        title = "Bag of Negative Sentiments",
        width = 6,
        background = "orange",
        shinycustomloader::withLoader(
          loader = spinner_type,
          wordcloud2::wordcloud2Output(outputId = "plt_bag_negative")
        )
      ),
      # row 2
      shinydashboard::box(
        title = "Sentiment Analysis (EmoLex)",
        width = 5,
        background = "black",
        shinycustomloader::withLoader(
          loader = spinner_type,
          plotOutput(outputId = "plt_emotion")
        )
      ),
      shinydashboard::box(
        title = "Sentiment Balance",
        background = "black",
        width = 3,
        shinycustomloader::withLoader(
          loader = spinner_type,
          plotOutput(outputId = "plt_sentiment")
        )
      ),
      shinydashboard::box(
        title = "Sources Contributing",
        width = 4,
        background = "black",
        shinycustomloader::withLoader(
          loader = spinner_type,
          plotOutput(outputId = "plt_media")
        )
      ),
      # row 3
      shinydashboard::box(
        title = "News analyzed",
        width = 12,
        shinycustomloader::withLoader(
          loader = spinner_type,
          DT::dataTableOutput(outputId = "tbl_sentiment")
        )
      )
    )
  ),
  footer = shinydashboardPlus::dashboardFooter(left = footerModule$htmlLeft, right = footerModule$htmlRight),
  title = "Sentiment On News"
)
