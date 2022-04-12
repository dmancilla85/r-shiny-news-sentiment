# syuzhetModule <- modules::module({
supported_langs <- c(
  "basque",
  "catalan",
  "no" = "danish",
  "nl" = "dutch",
  "en" = "english",
  "esperanto",
  "finnish",
  "fr" = "french",
  "de" = "german",
  "irish",
  "it" = "italian",
  "latin",
  "pt" = "portuguese",
  "romanian",
  "somali",
  "es" = "spanish",
  "sudanese",
  "swahili",
  "swedish",
  "turkish",
  "vietnamese",
  "welsh",
  "zulu"
)



#' Get corpus document
#'
#' This function analyzes the news dataframe with the NRC method.
#'
getCorpus <- function(text_v, language) {
  txt_new_corpus <- tm::Corpus(tm::VectorSource(text_v))
  toSpace <- tm::content_transformer(function(x, pattern) gsub(pattern, " ", x))

  # clean and tidy
  txt_new_corpus <- tm::tm_map(txt_new_corpus, toSpace, "/")
  txt_new_corpus <- tm::tm_map(txt_new_corpus, toSpace, "\n")
  txt_new_corpus <- tm::tm_map(txt_new_corpus, toSpace, "\r")
  txt_new_corpus <- tm::tm_map(txt_new_corpus, toSpace, "@")
  txt_new_corpus <- tm::tm_map(txt_new_corpus, toSpace, "\\|")
  txt_new_corpus <- tm::tm_map(txt_new_corpus, toSpace, "‘")
  txt_new_corpus <- tm::tm_map(txt_new_corpus, toSpace, "“")
  txt_new_corpus <- tm::tm_map(txt_new_corpus, toSpace, "”")
  txt_new_corpus <- tm::tm_map(txt_new_corpus, toSpace, "’")
  # Convert the text to lower case
  txt_new_corpus <- tm::tm_map(txt_new_corpus, tm::content_transformer(tolower))
  # Remove numbers
  txt_new_corpus <- tm::tm_map(txt_new_corpus, tm::removeNumbers)
  # Remove english common stopwords
  txt_new_corpus <- tm::tm_map(txt_new_corpus, tm::removeWords, tm::stopwords(language))
  # Remove punctuations
  txt_new_corpus <- tm::tm_map(txt_new_corpus, tm::removePunctuation)
  # Eliminate extra white spaces
  txt_new_corpus <- tm::tm_map(txt_new_corpus, tm::stripWhitespace)

  return(txt_new_corpus)
}

#' Format and clean data
#'
#' This function cleans and tidy the data
#'
previousDataCleaning <- function(df) {
  aux <- df

  aux$id <- (1:nrow(aux))

  Encoding(aux$title) <- "UTF-8"
  Encoding(aux$description) <- "UTF-8"
  Encoding(aux$url) <- "UTF-8"
  Encoding(aux$urlToImage) <- "UTF-8"
  Encoding(aux$content) <- "UTF-8"
  Encoding(aux$source.name) <- "UTF-8"

  aux <- aux %>% dplyr::mutate(content = stringr::str_replace(content, "/", " "))
  aux <- aux %>% dplyr::mutate(content = stringr::str_replace(content, "\n", " "))
  aux <- aux %>% dplyr::mutate(content = stringr::str_replace(content, "\r", " "))
  aux <- aux %>% dplyr::mutate(content = stringr::str_replace(content, "@", " "))
  aux <- aux %>% dplyr::mutate(content = stringr::str_replace(content, "\\|", " "))
  aux <- aux %>% dplyr::mutate(content = stringr::str_replace(content, "‘", " "))
  aux <- aux %>% dplyr::mutate(content = stringr::str_replace(content, "“", " "))
  aux <- aux %>% dplyr::mutate(content = stringr::str_replace(content, "”", " "))
  aux <- aux %>% dplyr::mutate(content = stringr::str_replace(content, "’", " "))

  aux$content <- gsub("[0-9.]", "", aux$content)

  return(aux)
}

#' Process news with NRC
#'
#' This function analyzes the news dataframe with the NRC method.
#'
processWithNRC <- function(df, lang = "es", target = "content") {
  language_code <- supported_langs[lang]

  if (nrow(df) == 0) {
    return(NULL)
  }

  df_res <- previousDataCleaning(df)

  # Collect all descriptions
  for (i in 1:nrow(df_res)) {
    sentence_v <- df_res[i, target]
    char_v <- syuzhet::get_sentences(sentence_v, fix_curly_quotes = TRUE)

    if (i == 1) {
      nrc_data <- syuzhet::get_nrc_sentiment(char_v, language = language_code)
      nrc_sum <- colSums(nrc_data)
      nrc_sum <- append(nrc_sum, i)
    } else {
      aux_data <- syuzhet::get_nrc_sentiment(char_v, language = language_code)
      aux_sum <- colSums(aux_data)
      aux_sum <- append(aux_sum, i)
      nrc_sum <- rbind(nrc_sum, aux_sum)
    }

    names(nrc_sum) <- c(
      "anger", "anticipation", "disgust", "fear", "joy",
      "sadness", "surprise", "trust", "negative",
      "positive", "id"
    )
  }

  df_nrc <- as.data.frame(nrc_sum)

  if (!is.array(nrc_sum)) {
    df_nrc <- t(df_nrc)
  }

  rownames(df_nrc) <- 1:nrow(df_nrc)

  df_res <- df_res %>%
    dplyr::inner_join(df_nrc, by = c("id" = "id"), copy = TRUE)

  return(df_res)
}

#' Get words with his meanings
#'
#' This function returns the words with his valences
#'
getWordsWithNRCValences <- function(df, lang = "es", target = "content") {
  if (nrow(df) == 0) {
    return(NULL)
  }

  language_code <- supported_langs[lang]
  df_res <- previousDataCleaning(df)

  # Collect all descriptions
  for (i in 1:nrow(df_res)) {
    sentence_v <- df_res[i, target]
    word <- syuzhet::get_sentences(sentence_v, fix_curly_quotes = TRUE)
    word <- get_tokens(word, pattern = "\\W")

    nrc <- syuzhet::get_nrc_sentiment(word, language = language_code)
    nrc <- nrc %>% dplyr::select(negative, positive)

    if (i == 1) {
      nrc_words <- cbind(word, nrc)
    } else {
      nrc_words <- rbind(nrc_words, cbind(word, nrc))
    }
  }

  df_nrc <- as.data.frame(nrc_words) %>%
    dplyr::filter(negative != 0 | positive != 0)

  df_nrc <- df_nrc %>%
    group_by(word) %>%
    summarise(
      positives = sum(positive),
      negatives = sum(negative)
    )

  return(df_nrc)
}

getSentimentValues <- function(nrc_data, translator) {
  nrc <- nrc_data %>%
    dplyr::select(
      -title,
      -description,
      -content,
      -url,
      -urlToImage,
      -source.name,
      -publishedAt
    ) %>%
    tidyr::pivot_longer(
      cols = c(
        "anger",
        "anticipation",
        "disgust",
        "fear",
        "joy",
        "sadness",
        "surprise",
        "trust",
        "negative",
        "positive"
      ),
      names_to = "Sentiment",
      names_repair = "unique"
    ) %>%
    dplyr::filter(Sentiment %in% c("positive", "negative"))

  nrc[nrc$Sentiment == "positive", ]$Sentiment <- translator$t("Positive")
  nrc[nrc$Sentiment == "negative", ]$Sentiment <- translator$t("Negative")

  data <- nrc %>%
    dplyr::select(Sentiment, value) %>%
    dplyr::filter(value != 0) %>%
    dplyr::group_by(Sentiment) %>%
    dplyr::summarise(valencia = sum(value))


  data$percent <- data$valencia / sum(data$valencia)
  data$label <- paste0(data$Sentiment, ": ", format(round(data$percent * 100, 2), nsmall = 2), "%")

  return(data)
}
# })
