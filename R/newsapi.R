
# news_api <- modules::module({
#   import("methods")
#   import("future")
#   import("httr")
#   import("dplyr")
#   import("stringr")
#   import("jsonlite")
#   import("urltools")
  
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

  EP_EVERYTHING <- "https://newsapi.org/v2/everything"
  EP_TOP_HEADLINES <- "https://newsapi.org/v2/top-headlines"

  # Sort criteria
  newsApiSortBy <- c("publishedAt", "relevancy", "popularity")

  newsApiCategories <-
    c(
      "general",
      "business",
      "entertainment",
      "health",
      "science",
      "sports",
      "technology"
    )



  # Functions ---------------------------------------------------------------


  #' Build the URL query for everything including titles
  #'
  buildQueryForEverythingTitles <- function(obj, currentPage) {
    query <- stringr::str_interp(
      paste0(
        "${EP_EVERYTHING}?apiKey=${obj$token}&",
        "qInTitle=${obj$query}&",
        "q=${obj$query}&",
        "language=${obj$language}&",
        "sortBy=${obj$sortBy}&",
        "pageSize=${obj$pageSize}&",
        "page=${currentPage}&",
        "from=${obj$from}&to=${obj$to}&wt=json"
      )
    )

    print(query)

    return(query)
  }

  #' Build the URL query for everything
  #'
  buildQueryForEverything <- function(obj, currentPage) {
    query <- stringr::str_interp(
      paste0(
        "${EP_EVERYTHING}?apiKey=${obj$token}&",
        "q=${obj$query}&",
        "language=${obj$language}&",
        "sortBy=${obj$sortBy}&",
        "pageSize=${obj$pageSize}&",
        "page=${currentPage}&",
        "from=${obj$from}&to=${obj$to}&wt=json"
      )
    )

    print(query)

    return(query)
  }

  #' Build the URL query for top headlines
  #'
  buildQueryForTopNews <- function(obj) {
    if (is.null(obj$category) || obj$category == "*") {
      query <- stringr::str_interp(
        paste0(
          "${EP_TOP_HEADLINES}?apiKey=${obj$token}&",
          "country=${obj$country}&",
          "language=${obj$language}&",
          "pageSize=${obj$pageSize}&",
          "wt=json"
        )
      )
    } else {
      query <- stringr::str_interp(
        paste0(
          "${EP_TOP_HEADLINES}?apiKey=${obj$token}&",
          "country=${obj$country}&",
          "language=${obj$language}&",
          "category=${obj$category}&",
          "pageSize=${obj$pageSize}&",
          "wt=json"
        )
      )
    }

    print(query)
    return(query)
  }

  #' Shows errors in a normalized format
  #'
  #' This is a generic function to display errors.
  #'
  showError <- function(err, type = "Error:") {
    print(paste(type, err$message))
    print(paste("Call:", err$call))
  }


  #' Converts the JSON response to a dataframe
  #'
  #' This function converts the JSON response to a single dataframe.
  #'
  convertFromJSON <- function(request) {
    json_top <- jsonlite::toJSON(
      request$articles,
      Date = "ISO8601",
      POSIXt = "ISO8601",
      null = "null",
      na = "null"
    )

    df_request <-
      jsonlite::fromJSON(
        json_top,
        simplifyDataFrame = T,
        flatten = T,
        simplifyVector = T
      )

    return(df_request)
  }


  #' Cleans and format the dataframe
  #'
  #' This function cleans the dataframe, and remove the useless fields.
  #'
  cleanAndFormat <- function(df_request) {
    # Cleaning data and format news API
    df_request$author <- NULL
    df_request$source.id <- NULL

    df_request$title <- unlist(df_request$title) # ok

    df_request$description <- as.character(df_request$description)
    df_request$description <- unlist(df_request$description) #

    df_request[df_request$description %in% c("", "NULL"), ]$description <-
      df_request[df_request$description %in% c("", "NULL"), ]$title

    df_request$url <- as.character(df_request$url)
    df_request$url <- unlist(df_request$url) # ok


    df_request$urlToImage <- as.character(df_request$urlToImage)
    df_request$urlToImage <- unlist(df_request$urlToImage) # ok

    df_request$publishedAt <- as.character(df_request$publishedAt)
    df_request$publishedAt <- unlist(df_request$publishedAt) # ok
    df_request$publishedAt <- as.Date(df_request$publishedAt)

    df_request$content <- as.character(df_request$content)
    df_request$content <- unlist(df_request$content)
    df_request$content <-
      stringr::str_replace_all(df_request$content, "chars]", "")
    df_request$content <-
      stringr::str_remove_all(df_request$content, "[+,0-9]")
    df_request$content <- gsub("\\[|\\]", "", df_request$content)

    df_request[df_request$content %in% c("", "NULL"), ]$content <-
      df_request[df_request$content %in% c("", "NULL"), ]$description

    df_request$source.name <- as.character(df_request$source.name)
    df_request$source.name <- unlist(df_request$source.name)

    return(df_request)
  }

  #' Verifies the API response
  #'
  #' This function verifies the API response and his status.
  #'
  verifyResponse <- function(response) {
    if (response$totalResults == 0) {
      return(NULL)
    }

    df <- data.frame(
      title = character(),
      description = character(),
      url = character(),
      urlToImage = character(),
      publishedAt = as.Date(character()),
      content = character(),
      source.name = character()
    )

    tryCatch(
      if (response$status != "ok") {
        print(paste("Current status is", response$status))
      } else {
        df <- convertFromJSON(response)
        df <- cleanAndFormat(df)
      },
      warning = function(err) {
        showError(err, "Warning")
      },
      error = function(err) {
        showError(err)
      }
    )

    return(df)
  }

  #' Get everything per page
  #'
  #' Query a page of articles available in NewsAPI between a date range.
  #'
  getEverythingPerPage <- function(obj,
                                   currentPage = 1) {
    print(obj)

    if (isTRUE(obj$searchInTitles)) {
      promise <- future::future(
        httr::GET(
          url = buildQueryForEverythingTitles(obj, currentPage)
        )
      ) %plan% future::multicore
    } else {
      promise <- future::future(
        httr::GET(
          url = buildQueryForEverything(obj, currentPage)
        )
      ) %plan% future::multicore
    }

    resp <- future::value(promise)
    jsonResponse <- jsonlite::fromJSON(httr::content(resp, "text"), simplifyVector = FALSE)
    df_response <- verifyResponse(jsonResponse)

    if (is.null(df_response)) {
      return(NULL)
    }

    cadena <- stringr::str_replace_all(urltools::url_decode(obj$query), '\"', "")

    print(cadena)

    if (obj$searchInTitles) {
      df_response <- df_response %>%
        dplyr::filter(stringr::str_detect(toupper(title), toupper(cadena)))
    } else {
      df_response <- df_response %>%
        dplyr::filter(stringr::str_detect(toupper(title), toupper(cadena)) |
          stringr::str_detect(toupper(description), toupper(cadena)))
    }

    return(df_response)
  }

  #' Get everything available in news
  #'
  #' Query all articles available in NewsAPI between a date range.
  #'
  getEverything <- function(obj,
                            freeAccountMode = TRUE) {
    df_response <- getEverythingPerPage(obj, 1)

    if (dim(df_response)[1] == 0 || isTRUE(freeAccountMode)) {
      return(df_response)
    }

    df_response$page <- 1

    totalPages <- as.integer(df_response$totalResults[1] / obj$pageSize)

    if (totalPages == 0) {
      print("No hay resultados")
      return(df_response)
    }

    if (totalPages == 1) {
      df_response$totalResults <- NULL
      return(df_response)
    }

    for (i in seq(2, totalPages, by = 1)) {
      aux <-
        getEverythingPerPage(obj, i)

      if (nrow(aux) == 0) {
        df_response$totalResults <- NULL
        return(df_response)
      }

      # Unir todos los resultados
      aux$page <- i
      df_response <- rbind(df_response, aux)
    }

    cadena <- stringr::str_replace_all(urltools::url_decode(obj$query), '\"', "")

    if (obj$searchInTitles) {
      df_response <- df_response %>%
        dplyr::filter(stringr::str_detect(toupper(title), toupper(cadena)))
    } else {
      df_response <- df_response %>%
        dplyr::filter(stringr::str_detect(toupper(title), toupper(cadena)) |
          stringr::str_detect(toupper(description), toupper(cadena)))
    }

    return(df_response)
  }


  #' Get newest headlines in news
  #'
  #' Retrieve newest headlines from News API.
  #'
  getTopHeadLines <-
    function(obj) {
      promise <- future::future(
        httr::GET(
          url = buildQueryForTopNews(obj)
        )
      ) %plan% future::multicore

      resp <- future::value(promise)
      jsonResponse <- jsonlite::fromJSON(
        httr::content(resp, "text"),
        simplifyVector = FALSE
      )
      df_response <- verifyResponse(jsonResponse)

      if (is.null(df_response)) {
        return(NULL)
      }

      cadena <- stringr::str_replace_all(urltools::url_decode(obj$query), '\"', "")

      if (obj$searchInTitles) {
        df_response <- df_response %>%
          dplyr::filter(stringr::str_detect(toupper(title), toupper(cadena)))
      } else {
        df_response <- df_response %>%
          dplyr::filter(stringr::str_detect(toupper(title), toupper(cadena)) |
            stringr::str_detect(toupper(description), toupper(cadena)))
      }

      return(df_response)
    }


  #' Get news invoker
  #'
  #' Retrieve newest headlines or everything from News API.
  #'
  getNews <- function(obj) {
    if (isTRUE(obj$topNews)) {
      df <- getTopHeadLines(obj)
      return(df)
    } else {
      df <- getEverything(obj)
      return(df)
    }
  }

#   export("NewsApi", "getNews")
# })
