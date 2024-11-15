source("./R/newsapi.R")
source("./R/sentiment.R")

# Obtener data
lang <- "en"

newsApi <- NewsApi(
  # Language
  p_from = "2022-07-16",
  # older as one month back (free User)
  p_to = "2022-07-18",
  p_country = "us",
  p_language = lang,
  # dates surround with "
  p_query = URLencode("covid"),
  # sort criteria
  p_topNews = FALSE,
)

df_req <- getNews(newsApi)
print(df_req)
nrc <- processWithNRC(df_req, lang)
print(nrc)
words <- getWordsWithNRCValences(df_req, lang)

print(words)


aux <- words |> dplyr::group_by(word) |> summarise(positives=sum(positives), negatives=sum(negatives))
which(aux$positives==max(aux$positives)) |> length()
View(aux)

words |> pivot_wider()

words |>
  group_by(publishedAt) |>
  summarise(Positive = sum(positives), Negative=sum(negatives)) |>
  pivot_longer(c(Positive, Negative), names_to = "Valence", values_to = "Count") |>
  filter(Count != 0)  |>
  ggplot(aes(x=publishedAt,y=Count, color=Valence)) + 
  geom_line(linewidth=1) + 
  ggtitle("Words Valence in The Time") +
  theme_dark() 

words |> 
  group_by(publishedAt) |>
  summarise(positives = sum(positives)) |>
  ggplot(aes(x=publishedAt,y=positives)) + geom_line(linewidth=2)


