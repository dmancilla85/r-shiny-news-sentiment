
# Define server logic
server <- function(input, output, session) {

  # show modal
  showModal(modalsModule$welcomeModal())

  observeEvent(input$close_modal, {
    removeModal()
  })

  observeEvent(input$sel_language, {
    shiny.i18n::update_lang(session, input$sel_language)
  })

  output$dt_fechas <- shiny::renderUI({
    shiny::dateRangeInput(
      inputId = "dt_fechas",
      label = i18n$t("Date range:"),
      min = Sys.Date() - 3,
      start = Sys.Date() - 3,
      max = Sys.Date(),
      end = Sys.Date(),
      format = i18n$t("mm/dd/yy"),
      language = input$sel_language,
      separator = " - "
    )
  })

  # TODO: revisar validez del analisis de sentimiento
  values <- shiny::reactiveValues()
  values$is_empty <- TRUE

  shiny::observeEvent(input$btn_start, {

    # disable action button
    shinyjs::disable("btn_start")

    values$date_range <- shiny::isolate(input$dt_fechas)
    values$caption_txt <- shiny::isolate(input$txt_caption)
    values$country <- shiny::isolate(input$sel_country)
    values$lang <- shiny::isolate(input$sel_language)
    values$category <- shiny::isolate(input$sel_category)
    values$top_news <- shiny::isolate(input$chk_latest_news)
    values$titles <- shiny::isolate(input$chk_search_titles)
    values$all_langs <- shiny::isolate(input$chk_all_languages)


    if (!is.null(values$date_range) &
      (!is.null(values$caption_txt) & stringr::str_length(values$caption_txt) >= 3)) {
      newsApi <- NewsApi(
        # Language
        p_from = values$date_range[1],
        # older as one month back (free User)
        p_to = values$date_range[2],
        p_country = values$country,
        p_language = values$lang,
        # dates surround with "
        p_query = URLencode(values$caption_txt),
        # sort criteria
        p_topNews = values$top_news,
        p_category = values$category,
        p_searchInTitles = values$titles
      )

      values$df_req <- getNews(newsApi)

      if (is.null(values$df_req) || nrow(values$df_req) == 0) {
        values$is_empty <- TRUE
        empty_msg <- i18n$t("No results")

        showModal(modalDialog(
          shiny::renderText(empty_msg),
          easyClose = TRUE,
          footer = NULL,
          size = "m"
        ))
      } else {
        values$is_empty <- FALSE
        # analyze the values

        inicio <- Sys.time()
        values$nrc <- processWithNRC(values$df_req, values$lang)
        fin <- Sys.time()
        print(str_interp("NRC_Emotions: ${difftime(fin,inicio,units='secs')} secs"))

        inicio <- Sys.time()
        values$words <- getWordsWithNRCValences(values$df_req, values$lang)
        fin <- Sys.time()
        print(str_interp("NRC_Words: ${difftime(fin,inicio,units='secs')} secs"))

        inicio <- Sys.time()
        values$sentiment <- getSentimentValues(values$nrc, translator = i18n)
        fin <- Sys.time()

        print(str_interp("NRC_Sentiment: ${difftime(fin,inicio,units='secs')} secs"))
      }
    }
  })

  output$plt_emotion <- shiny::renderPlot({
    title <- stringr::str_to_title(
      stringr::str_interp("Emotion on news mentioning '${values$caption_txt}'")
    )
    # subtitle <- i18n$t("NRC Sentiment Analysis (EmoLex)")

    if (values$is_empty) {
      ggplot2::ggplot() +
        ggplot2::geom_blank()
    } else {
      # enable action button
      shinyjs::enable("btn_start")

      values$nrc %>%
        plotEmolex(plot_title = title, translator = i18n)
    }
  })

  output$plt_media <- shiny::renderPlot({
    if (values$is_empty) {
      ggplot2::ggplot() +
        ggplot2::geom_blank()
    } else {
      # show plot
      values$nrc %>%
        plotSources()
    }
  })

  # output$plt_sentiment <- shiny::renderPlot({
  #   if (values$is_empty) {
  #     ggplot2::ggplot() +
  #       ggplot2::geom_blank()
  #   } else {
  #     # show plot
  #     plotSentiment(sentiment_data = values$sentiment, translator = i18n)
  #   }
  # })

  output$plt_bag_positive <- wordcloud2::renderWordcloud2({
    if (values$is_empty) {
      # do nothing
    } else {
      values$words %>%
        filter(positives != 0) %>%
        select(word, freq = positives) %>%
        wordcloud2a(size = 1, color = "random-dark")
    }
  })

  output$plt_bag_negative <- wordcloud2::renderWordcloud2({
    if (values$is_empty) {
      # do nothing
    } else {
      values$words %>%
        filter(negatives != 0) %>%
        select(word, freq = negatives) %>%
        wordcloud2a(size = 1, color = "random-dark")
    }
  })

  output$box_keyword <- renderInfoBox({
    value <- "Empty now"

    if (!values$is_empty) {
      value <- stringr::str_to_title(values$caption_txt)
    }

    infoBox(
      "Keyword", value,
      icon = icon("wind", lib = "font-awesome"),
      color = "aqua"
    )
  })

  output$box_positive <- renderInfoBox({
    value <- 0.00
    
    if (!values$is_empty) {
      value <- format(values$sentiment[2, "percent"] * 100, digits = 4)
    }
    
    infoBox(
      "Positive", stringr::str_interp("${value}%"), 
      icon = icon("thumbs-up", lib = "font-awesome"),
      color = "green"
    )
  })
  
  output$box_negative <- renderInfoBox({
    value <- 0.00
    
    if (!values$is_empty) {
      value <- format(values$sentiment[1, "percent"] * 100, digits = 4)
    }
    
    infoBox(
      "Negative", stringr::str_interp("${value}%"), 
      icon = icon("thumbs-down", lib = "font-awesome"),
      color = "red"
    )
  })

  output$tbl_sentiment <- renderNewsTable(values)

  output$txt_caption <- shiny::renderUI({
    htmltools::HTML("<p>Sentiment Analisys by David A. Mancilla. 2021</p>")
  })
}
