
modalsModule <- modules::module({
  welcomeModal <- function() {
    shiny::modalDialog(
      easyClose = T,
      shiny::tags$div(
        class = "modal-window",
        shiny::tags$h2("Welcome to Sentiment on News"),
        shiny::div( class="modal-content",
          shiny::tags$div(
            class = "modal-help-text",
            shiny::tags$h3("Quick start"),
            shiny::tags$p(
              shiny::tags$ul(
                shiny::tags$li("Choose a language"),
                shiny::tags$li("Check Top headlines to get the breaking news, otherwise will get the news in the last 4 days"),
                shiny::tags$li("Select a country (Only in Top headlines)"),
                shiny::tags$li("Write the keyword and clic on Search button")
              )
            )
          ),
          shiny::tags$div(
            class = "welcome-modal",
            shiny::tags$img(class = "image-modal", src = "5057942.jpg")
          )
        )
      ),
      footer = NULL
    )
  }
})
