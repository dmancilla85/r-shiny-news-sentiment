source("./R/newsapi.R")
source("./R/sentiment.R")

# Obtener data
lang <- "en"

newsApi <- NewsApi(
  # Language
  p_from = "2022-04-04",
  # older as one month back (free User)
  p_to = "2022-04-06",
  p_country = "us",
  p_language = lang,
  # dates surround with "
  p_query = URLencode("covid"),
  # sort criteria
  p_topNews = FALSE,
)

df_req <- getNews(newsApi)

nrc <- processWithNRC(df_req, lang)

words <- getWordsWithNRCValences(df_req)

data <- c("no","data")
data <- cbind(data,c(1,1))


wordcloud2(as.data.frame(data),size=1.6, color='random-dark')


