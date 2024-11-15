# R Shiny News-Sentiment v. 1.1.0

This application searches for a word in the headlines or summary of news stories obtained from different sources using a news API. Once the matches are obtained, it explores the emotional valence in the words obtained in each of the articles. It uses the syuzhet package and analyzes the words with the NRC emotion lexicon (aka EmoLex). It associates each word with 8 emotions (anger, anticipation, disgust, fear, joy, sadness, surprise, confidence), and an emotional valence (negative, positive or neutral). Thus, words are ranked according to the emotions they represent and the emotional valence (or charge) of the authors.

Possible biases:

1. Misinterpretation or mistranslation of words in languages other than the original NRC lexicon (English).
2. Availability of news sources.
3. Data consumption and date range limitations (due to the use of a free NewsAPI account).

## CHANGELOG
* v1.1.0 2022-08-19: Added details in welcome modal and UI improvements
* v1.0.2 2022-08-17: Fixed some visual details in footer and welcome-modal
* v1.0.1 2022-08-08: Added two plots with the bag of positive and negative words
* v1.0.0 2022-08-07: Added a single indicator for positive/negative

## TODO 
* Fill this document - the text here will be the same in Linkedin publication

## BACKLOG
* Add testthat
* Download plots as SVG 
* Use plotly/interactive plot
* Restore the i18n UI
* Add pie plot showing which sources are contributing more to final score

## DEV NOTES
In the main path, add a .Renviron file with the following content:

```
NEWS_API_TOKEN = "<YOUR_API_KEY>"
```

Get your API key on [NewsApi.Org](https://newsapi.org/).

Use renv::snapshot() to update the .lockfile.

## Concepts:
- GitHub
- API REST
- R Environment
- Data cleaning
- Data transformation
- Data visualization
- Test That
- Docker
- Shiny Single Page App
- Shiny Dashboard
- Datatables
- Internationalization
- CSS styles
- Shiny Cloud Apps
