#' Plot NRC results
#'
#' This function plots the sentiment analysis with NRC.
#'
plotSentiment <- function(plot_data, plot_title, plot_subtitle, translator) {
  caption <- ""

  custom_theme <- ggplot2::theme(
    strip.background = ggplot2::element_blank(),
    panel.border = ggplot2::element_rect(fill = NA, color = "white"),
    panel.grid.minor = ggplot2::element_blank(),
    plot.title = ggplot2::element_text(size = 16),
    plot.subtitle = ggplot2::element_text(size = 14, color = "darkcyan"),
    axis.text = ggplot2::element_text(size = 12),
    axis.title = ggplot2::element_text(size = 14, color = "darkcyan", face = "italic"),
    panel.grid = ggplot2::element_blank()
  )


  nrc <- plot_data %>%
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
      names_to = "Sentimiento",
      names_repair = "unique"
    ) %>%
    dplyr::filter(!(Sentimiento %in% c("positive", "negative", "trust")))

  nrc[nrc$Sentimiento == "anger", ]$Sentimiento <- translator$t("Anger")
  nrc[nrc$Sentimiento == "anticipation", ]$Sentimiento <- translator$t("Anticipation")
  nrc[nrc$Sentimiento == "disgust", ]$Sentimiento <- translator$t("Disgust")
  nrc[nrc$Sentimiento == "fear", ]$Sentimiento <- translator$t("Fear")
  nrc[nrc$Sentimiento == "joy", ]$Sentimiento <- translator$t("Joy")
  nrc[nrc$Sentimiento == "sadness", ]$Sentimiento <- translator$t("Sadness")
  nrc[nrc$Sentimiento == "surprise", ]$Sentimiento <- translator$t("Surprise")

  
  data <- nrc %>%
    dplyr::select(Sentimiento, value) %>%
    dplyr::filter(value != 0) %>%
    dplyr::group_by(Sentimiento) %>%
    dplyr::summarise(valencia = sum(value))

  data$fraction <- data$valencia / sum(data$valencia)
  
  # Compute the cumulative percentages (top of each rectangle)
  data$ymax <- cumsum(data$fraction)
  
  # Compute the bottom of each rectangle
  data$ymin <- c(0, head(data$ymax, n = -1))
  
  # Compute label position
  data$labelPosition <- (data$ymax + data$ymin) / 2
  
  # Compute a good label
  data$label <- paste0(data$Sentimiento, "\n",format(round(data$fraction*100, 2), nsmall = 2),"%")
  
  # Make the plot
  plot <- ggplot(data, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=Sentimiento)) +
    geom_rect() +
    geom_text( x=2, aes(y=labelPosition, label=label, color="black"), size=5) + 
    # x here controls label position (inner / outer)
    #scale_fill_brewer(palette=3) +
    scale_color_brewer(palette=3) +
    coord_polar(theta="y") +
    xlim(c(-1, 4)) +
    theme_void() +
    theme(legend.position = "none")
  
  
  #custom_breaks <- unique(sort(nrc$valencia))

  #plot <- nrc %>% ggplot2::ggplot(ggplot2::aes(
  #  x = Sentimiento, y = valencia, fill = Sentimiento # , fill = source.name
  #)) +
  #  ggplot2::geom_bar(stat = "identity") +
  #  ggplot2::ggtitle(plot_title, plot_subtitle) +
  #  ggplot2::labs(caption = caption) +
  #  ggplot2::coord_flip() +
  #  ggplot2::xlab(translator$t("Sentiment")) +
  #  ggplot2::ylab(translator$t("NRC EmoLex Score")) +
  #  ggplot2::theme_gray() +
  #  custom_theme +
  #  ggplot2::scale_y_continuous(breaks = custom_breaks, limits = c(0, max(custom_breaks))) +
  #  ggplot2::guides(fill = "none") +
  #  ggplot2::scale_color_brewer()

  return(plot)
}

plotSourcesContribution <- function(plot_data) {
  sources <- plot_data %>%
    dplyr::select(
      source.name
    )

  data <- sources %>% count(source.name, name = "count")


  # Create test data.
  # data <- data.frame(
  #  category=c("A", "B", "C"),
  #  count=c(10, 60, 30)
  # )

  # Compute percentages
  data$fraction <- data$count / sum(data$count)

  # Compute the cumulative percentages (top of each rectangle)
  data$ymax <- cumsum(data$fraction)

  # Compute the bottom of each rectangle
  data$ymin <- c(0, head(data$ymax, n = -1))

  # Compute label position
  data$labelPosition <- (data$ymax + data$ymin) / 2

  # Compute a good label
  data$label <- paste0(data$source.name, "\n value: ", data$count)

  # Make the plot
  plot <- ggplot(data, aes(ymax = ymax, ymin = ymin, xmax = 4, xmin = 3, fill = source.name)) +
    geom_rect() +
    geom_text(x = 2, aes(y = labelPosition, label = label, color = "darkgrey"), size =4) +
    # x here controls label position (inner / outer)
    #scale_fill_brewer(palette = "Set3") +
    scale_color_brewer(palette = "Set3") +
    coord_polar(theta = "y") +
    xlim(c(-1, 4)) +
    theme_void() +
    theme(legend.position = "none")
  


  return(plot)
}
