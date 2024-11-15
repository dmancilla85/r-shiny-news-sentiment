indicators <- bslib::layout_columns(
  fill = FALSE,
  min_height = "150px",
  max_height = "150px",
  bslib::value_box(title = "Keyword",
    value = 0, showcase = bsicons::bs_icon("megaphone")),
  bslib::value_box(title = "Positive sentiment",
    value = 0, showcase = bsicons::bs_icon("emoji-smile-fill")),
  bslib::value_box(title = "Negative sentiment",
    value = 0, showcase = bsicons::bs_icon("emoji-angry-fill")),
  bslib::value_box(title = "Mentions",
    value = 0, showcase = bsicons::bs_icon("newspaper"))
)
 
 cards <- bslib::accordion(
  accordion_panel(
    #full_screen = TRUE,
    title = "Positive words",
    shinycustomloader::withLoader(
      loader = spinner_type,
      wordcloud2::wordcloud2Output(outputId = "plt_bag_positive")
    )
  ),
  accordion_panel(
    #full_screen = TRUE,
    #card_header("Negative words"),
    title = "Negative words",
      shinycustomloader::withLoader(
        loader = spinner_type,
        wordcloud2::wordcloud2Output(outputId = "plt_bag_negative")
    )
  ),
  accordion_panel(
    #full_screen = TRUE,
    #card_header("Sentiment (EmoLex)"),
    title = "Sentiment (EmoLex)",
    shinycustomloader::withLoader(
      loader = spinner_type,
      plotOutput(outputId = "plt_emotion")
    )
  ),
  accordion_panel(
    #full_screen = TRUE,
    #card_header("Valence Time"),
    title = "Valence Time",
    shinycustomloader::withLoader(
      loader = spinner_type,
      plotOutput(outputId = "plt_valence_time")
    )
  ),
  accordion_panel(
    #full_screen = TRUE,
    #card_header("Sentiment by Media"),
    title = "Sentiment by Media",
    shinycustomloader::withLoader(
      loader = spinner_type,
      plotOutput(outputId = "plt_media")
    )
  ),
  accordion_panel(
    #full_screen = TRUE,
    #card_header("News Analyzed"),
    title = "News Analyzed",
    shinycustomloader::withLoader(
      loader = spinner_type,
      DT::dataTableOutput(outputId = "tbl_sentiment")
    )
  )
)

select_language <- shiny::selectInput(
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
)

checkbox_search_mode <- shiny::checkboxInput(
  inputId = "chk_latest_news", label = i18n$t("Top headlines"),
  value = FALSE
)

select_country <- shiny::selectInput(
  inputId = "sel_country",
  label = i18n$t("Country"),
  selected = "us",
  choices = dataModule$getAvailableCountries()
)

select_category <- shiny::selectInput(
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

date_picker <- shiny::uiOutput(outputId = "dt_fechas")

check_search_in_title <- shiny::checkboxInput(
  inputId = "chk_search_titles",
  label = i18n$t("Only analize headlines"),
  value = FALSE
)
 
text_keyword <- shiny::textInput(
  inputId = "txt_caption",
  label = i18n$t("Keyword"),
  value = NULL,
  placeholder = ""
)

button_search <- shiny::actionButton(inputId = "btn_start", label = i18n$t("Search"), icon = icon("search"))

 ui_v2 <- bslib::page_sidebar(
  title = "Sentiment in the News",
  sidebar = bslib::sidebar(
    title=i18n$t("Options"),
    select_language,
    checkbox_search_mode,
   shiny::conditionalPanel(
     condition = "input.chk_latest_news == true",
     select_country,
     select_category
   ),
   shiny::conditionalPanel(
     condition = "input.chk_latest_news == false",
     date_picker,
     check_search_in_title
   ),
   text_keyword,
   button_search
  ),
  indicators,
  cards,
  #bslib::layout_columns(
  #  col_widths = c(6, 6, 12, 12, 12, 12),
  #  row_heights = c(3, 3 ,3 ,3 ,3, 3),
  #  cards[[1]],
  #  cards[[2]],
  #  cards[[3]],
  #  cards[[4]],
  #  cards[[5]],
  #  cards[[6]]
  #),
  "hola footer",
  shiny::conditionalPanel(
    condition = "$('html').hasClass('shiny-busy')",
    htmltools::tags$div(i18n$t("Working, please wait..."), id = "loadmessage")
  )
)
    
