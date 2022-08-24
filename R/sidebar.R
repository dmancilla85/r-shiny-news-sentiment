# sidebar.R

showSidebar <- # Sidebar with a slider input for number of bins
  function(i18n) {
    shinydashboard::dashboardSidebar(
      collapsed = FALSE,
      shiny::selectInput(
        inputId = "sel_language",
        label = i18n$t("Language"),
        selected = i18n$get_key_translation(),
        choices = c(
          # "Arab" = "ar",
          "Deutsche" = "de",
          "Español" = "es",
          "English" = "en",
          "Françoise" = "fr",
          "Portuguese" = "pt",
          "Italiano" = "it",
          "Norsk" = "no",
          "Dutch" = "nl"
        ),
      ),
      shiny::checkboxInput(
        inputId = "chk_latest_news", label = i18n$t("Top headlines"),
        value = FALSE
      ),
      shiny::conditionalPanel(
        condition = "input.chk_latest_news == true",
        shiny::selectInput(
          inputId = "sel_country",
          label = i18n$t("Country"),
          selected = "us",
          choices = dataModule$getAvailableCountries()
        ),
        shiny::selectInput(
          inputId = "sel_category",
          label = i18n$t("Category"),
          selected = "*",
          selectize = T,
          choices = c(
            "All" = "*",
            "General" = "general",
            "Business" = "business",
            "Entertainment" = "entertainment",
            "Health" = "health",
            "Science" = "science",
            "Sports" = "sports",
            "Technology" = "technology"
          )
        )
      ),
      shiny::conditionalPanel(
        condition = "input.chk_latest_news == false",
        shiny::uiOutput(outputId = "dt_fechas"),
        shiny::checkboxInput(
          inputId = "chk_search_titles",
          label = i18n$t("Only analize headlines"),
          value = FALSE
        )
      ),
      shiny::textInput(
        inputId = "txt_caption",
        label = i18n$t("Keyword"),
        value = NULL,
        placeholder = ""
      ),
      shiny::actionButton(inputId = "btn_start", label = i18n$t("Search"), icon = icon("search"))
    )
  }
