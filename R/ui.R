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
    shinyjs::useShinyjs(),
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
    # Spinner
    shinybusy::add_busy_spinner(spin = "semipolar", height = "200px", 
                     width = "200px", margins = c(30, 30), color = "#fff"),
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
        status = "warning",
        solidHeader = TRUE,
        collapsible = TRUE,
        shinycustomloader::withLoader(
          loader = spinner_type,
          wordcloud2::wordcloud2Output(outputId = "plt_bag_positive")
        )
      ),
      shinydashboard::box(
        title = "Bag of Negative Sentiments",
        width = 6,
        status = "warning",
        solidHeader = TRUE,
        collapsible = TRUE,
        shinycustomloader::withLoader(
          loader = spinner_type,
          wordcloud2::wordcloud2Output(outputId = "plt_bag_negative")
        )
      ),
      
      # row 2
      infoBoxOutput("box_keyword",width = 4),
      infoBoxOutput("box_positive",width = 4),
      infoBoxOutput("box_negative",width = 4),
      
      # row 3
      shinydashboard::box(
        title = "Sentiment Analysis (EmoLex)",
        width = 7,
        status = "primary",
        solidHeader = TRUE,
        collapsible = TRUE,
        shinycustomloader::withLoader(
          loader = spinner_type,
          plotOutput(outputId = "plt_emotion")
        )
      ),
      # shinydashboard::box(
      #   title = "Sentiment Balance",
      #   status = "primary",
      #   solidHeader = TRUE,
      #   collapsible = TRUE,
      #   width = 3,
      #   shinycustomloader::withLoader(
      #     loader = spinner_type,
      #     plotOutput(outputId = "plt_sentiment")
      #   )
      # ),
      shinydashboard::box(
        title = "Sources Contributing",
        width = 5,
        status = "primary",
        solidHeader = TRUE,
        collapsible = TRUE,
        shinycustomloader::withLoader(
          loader = spinner_type,
          plotOutput(outputId = "plt_media")
        )
      ),
      # row 4
      shinydashboard::box(
        title = "News analyzed",
        width = 12,
        status = "warning",
        solidHeader = TRUE,
        collapsible = TRUE,
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
