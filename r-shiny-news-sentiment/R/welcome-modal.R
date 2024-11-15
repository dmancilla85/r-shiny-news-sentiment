# welcome-modal.R

modalsModule <- modules::module({
  welcomeModal <- function() {
    shiny::modalDialog(
      easyClose = T,
      shiny::div(
        class = "modal-window",
        shiny::tags$h2("Welcome to Sentiment on News"),
        shiny::div(
          class = "modal-content",
          shiny::div(
            class = "modal-help-text",
            shiny::tags$h3("Quick start"),
            shiny::tags$p(
              "This application searches for a word in the headlines or summary of news obtained from different sources using a News API. Once the matches are obtained, it explores the emotional valence of the words obtained from the texts.",
              shiny::tags$ul(
                shiny::tags$li("Choose a language."),
                shiny::tags$li("Check 'Top headlines' to search in the latest news, otherwise will search over all the news in the last 4 days."),
                shiny::tags$li("If you check the 'Top Headlines' option, you need to choose a country."),
                shiny::tags$li("Write the keyword you want to search and then click on Search button.")
              )
            )
          ),
          shiny::div(
            class = "welcome-modal",
            shiny::tags$img(class = "image-modal", src = "5057942.jpg")
          ),
          shiny::div(
            class = "modal-foot-text",
            shiny::p(
              "Sentiment on News, ©2022. Developed by David A. Mancilla (david.a.m@live.com).\nWelcome ilustration designed by stories/Freepik."
            )
          )
        )
      ),
      footer = 
        shiny::modalButton("Ok")
    )
  }
})
