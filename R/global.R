# global.R

source("./R/libraries.R", local = TRUE, encoding = c("UTF-8"))

loadAllLibraries()

# TODO: Agregar gráfico de tortas mostrando que fuentes aportan mas al puntaje final

i18n <- Translator$new(translation_json_path = "./data/translation.json")
i18n$set_translation_language("en")

# NewsApi configuration object
NewsApi <- setRefClass(
  "NewsAPI",
  fields = list(
    token = "character",
    pageSize = "numeric",
    country = "character",
    language = "character",
    sortBy = "character",
    from = "character",
    to = "character",
    query = "character",
    searchInTitles = "logical",
    topNews = "logical",
    category = "character"
  ),
  methods = list(
    initialize = function(p_pageSize = 100,
                          p_country = "ar",
                          p_language = "es",
                          p_sortBy = "publishedAt",
                          p_from = "",
                          p_to = "",
                          p_query = "",
                          p_searchInTitles = FALSE,
                          p_topNews = FALSE,
                          p_category = "general") {
      .self$token <- Sys.getenv("NEWS_API_TOKEN") # "f4a88e83555a4ffd91669835d38efedf"
      .self$pageSize <- p_pageSize
      .self$country <- p_country
      .self$language <- p_language
      .self$sortBy <- p_sortBy
      .self$from <- paste('"', p_from, '"', sep = "")
      .self$to <- paste('"', p_to, '"', sep = "")
      .self$query <- p_query # paste('"', urltools::url_encode(p_query), '"', sep = "")
      .self$searchInTitles <- p_searchInTitles
      .self$topNews <- p_topNews
      .self$category <- p_category
    }
  )
)