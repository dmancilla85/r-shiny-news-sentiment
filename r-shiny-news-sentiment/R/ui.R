# Options
# spinners <- c("dnaspin","pacman")
spinner_type <- "dnaspin"

# Define UI for application that draws a histogram
ui <- dashboardPage(
  skin = "yellow",
  options = list(sidebarExpandOnHover = TRUE),
  header = dashboardHeader(
    title = "Sentiment on News",
    controlbarIcon = shiny::icon("bars"),
    tags$li(
      class = "dropdown",
      shinyWidgets::actionBttn("info", "", style = "minimal", icon = icon("info"))
    )
  ),
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
    shinybusy::add_busy_spinner(
      spin = "semipolar", height = "200px",
      width = "200px", margins = c(40, 40), color = "#fff"
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
    shinyBS::bsTooltip("txt_caption", "Enter the keyword to search",
      "right",
      options = list(container = "body", animation = "true")
    ),
    fluidRow( # row 1
      valueBoxOutput("box_keyword", width = 3),
      valueBoxOutput("box_positive", width = 3),
      valueBoxOutput("box_negative", width = 3)
    ),
    fluidRow( # row 2
      shinydashboard::box(
        title = "Positive Words",
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
        title = "Negative Words",
        width = 6,
        status = "warning",
        solidHeader = TRUE,
        collapsible = TRUE,
        shinycustomloader::withLoader(
          loader = spinner_type,
          wordcloud2::wordcloud2Output(outputId = "plt_bag_negative")
        )
      ),

      # row 3
      shinydashboard::box(
        title = "Sentiment Analysis (EmoLex)",
        width = 12,
        status = "primary",
        solidHeader = TRUE,
        collapsible = FALSE,
        shinycustomloader::withLoader(
          loader = spinner_type,
          plotOutput(outputId = "plt_valence_time")
          # )
        ),

        # row 4
        # shinydashboard::box(
        #   title = "Sentiment Analysis (EmoLex)",
        #   width = 7,
        #   status = "primary",
        #   solidHeader = TRUE,
        #   collapsible = TRUE,
        shinycustomloader::withLoader(
          loader = spinner_type,
          plotOutput(outputId = "plt_emotion")
          # )
        ),
        # shinydashboard::box(
        #   title = "Media Sources",
        #   width = 5,
        #   status = "primary",
        #   solidHeader = TRUE,
        #   collapsible = TRUE,
        shinycustomloader::withLoader(
          loader = spinner_type,
          plotOutput(outputId = "plt_media")
        )
      ),

      # row 5
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
    ),
    shiny::conditionalPanel(
      condition = "$('html').hasClass('shiny-busy')",
      htmltools::tags$div(i18n$t("Working, please wait..."), id = "loadmessage")
    )
  ),
  footer = shinydashboardPlus::dashboardFooter(left = footerModule$htmlLeft, right = footerModule$htmlRight),
  title = "Sentiment On News"
)
