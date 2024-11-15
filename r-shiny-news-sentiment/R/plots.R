# plots.R

#' Customized palettes'
dry_rosewood <- c("#745250", "#9a5e5c", "#e7cabf", "#d98288", "#e9a093")

#' Plot NRC results
#'
#' This function plots the sentiment analysis with NRC.
#'
plotEmolex <- function(plot_data, plot_title, translator) {
  caption <- ""

  custom_theme <- ggplot2::theme(
    legend.position = "none",
    panel.grid = ggplot2::element_blank(),
    strip.background = ggplot2::element_blank(),
    plot.title = ggplot2::element_text(size = 15, hjust = 0.5, face = "bold"),
    plot.subtitle = ggplot2::element_text(size = 13, color = "darkcyan", hjust = 0.5),
    panel.border = ggplot2::element_rect(fill = NA, color = "white"),
    panel.grid.minor = ggplot2::element_blank(),
    panel.grid.major = ggplot2::element_blank(),
    axis.text = ggplot2::element_blank(),
    axis.title = ggplot2::element_blank(),
    axis.ticks = ggplot2::element_blank()
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
    dplyr::filter(!(Sentimiento %in% c("positive", "negative")))

  nrc[nrc$Sentimiento == "anger", ]$Sentimiento <- translator$t("Anger")
  nrc[nrc$Sentimiento == "anticipation", ]$Sentimiento <- translator$t("Anticipation")
  nrc[nrc$Sentimiento == "disgust", ]$Sentimiento <- translator$t("Disgust")
  nrc[nrc$Sentimiento == "fear", ]$Sentimiento <- translator$t("Fear")
  nrc[nrc$Sentimiento == "joy", ]$Sentimiento <- translator$t("Joy")
  nrc[nrc$Sentimiento == "sadness", ]$Sentimiento <- translator$t("Sadness")
  nrc[nrc$Sentimiento == "surprise", ]$Sentimiento <- translator$t("Surprise")
  nrc[nrc$Sentimiento == "trust", ]$Sentimiento <- translator$t("Trust")


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
  data$label <- paste0(data$Sentimiento, "\n", format(round(data$fraction * 100, 2), nsmall = 2), "%")

  # Make the plot
  plot <- ggplot2::ggplot(data, ggplot2::aes(
    ymax = ymax, ymin = ymin, xmax = 4, xmin = 3,
    fill = Sentimiento
  )) +
    ggplot2::geom_rect(color = "whitesmoke") +
    ggplot2::ggtitle(plot_title) +
    ggrepel::geom_text_repel(x = 2, ggplot2::aes(y = labelPosition, label = label), size = 4) +
    # x here controls label position (inner / outer)
    ggplot2::scale_fill_brewer(palette = 3) +
    ggplot2::scale_color_brewer(palette = 3) +
    ggplot2::coord_polar(theta = "y") +
    ggplot2::xlim(c(-1, 4)) +
    custom_theme

  return(plot)
}

#' Plot Media Sources
#'
#' This function plots the number of articles published by each media
#'
plotSources <- function(plot_data) {
  sources <- plot_data %>%
    dplyr::select(
      source.name
    )

  custom_theme <- ggplot2::theme(
    legend.position = "none",
    plot.title = ggplot2::element_text(size = 15, hjust = 0.5, face = "bold"),
    plot.subtitle = ggplot2::element_text(size = 13, color = "darkcyan", hjust = 0.5),
    axis.title.x = ggplot2::element_blank(),
    axis.title.y = ggplot2::element_blank(),
    axis.ticks = ggplot2::element_blank(),
    panel.background = element_blank()
  )

  data <- sources %>% count(source.name, name = "count")
  data$source.name <- as.factor(data$source.name)
  # count the needed levels of a factor
  number <- nlevels(data$source.name)

  # repeat the given colors enough times
  rose_palette <- rep(dry_rosewood, length.out = number)


  title <- stringr::str_to_title("Articles Published by Each Media")

  by_ticks <- 3

  if (max(data$count == 1)) {
    by_ticks <- 1
  }

  if (max(data$count) %% 2 == 0) {
    by_ticks <- 2
  }

  plot <- data %>% ggplot2::ggplot(ggplot2::aes(x = source.name, y = count, fill = source.name)) +
    ggplot2::geom_bar(stat = "identity", color = "#777777") +
    ggplot2::scale_fill_manual(values = rose_palette) +
    ggplot2::scale_y_continuous(
      labels = scales::label_number(accuracy = 1),
      breaks = seq(from = 0, to = max(data$count), by = by_ticks)
    ) +
    ggplot2::coord_flip() +
    ggplot2::ggtitle(title) +
    custom_theme

  return(plot)
}

#' Plot sentiment results
#'
#' This function plots the sentiment analysis with NRC.
#'
plotSentiment <- function(sentiment_data, translator) {
  title <- stringr::str_to_title("Summary of all the words analyzed")

  custom_theme <- ggplot2::theme(
    axis.title.x = ggplot2::element_blank(),
    axis.ticks.x = ggplot2::element_blank(),
    axis.title.y = ggplot2::element_blank(),
    axis.ticks.y = ggplot2::element_blank(),
    axis.text.x = ggplot2::element_blank(),
    axis.text.y = ggplot2::element_blank(),
    strip.background = ggplot2::element_blank(),
    panel.grid.minor = ggplot2::element_blank(),
    panel.grid.major = ggplot2::element_blank(),
    legend.position = "none",
    plot.title = ggplot2::element_text(size = 15, hjust = 0.5, face = "bold"),
    plot.subtitle = ggplot2::element_text(size = 13, color = "darkcyan", hjust = 0.5)
  )

  plot <- sentiment_data |> ggplot2::ggplot(aes(x = 0.5, y = valencia, fill = Sentiment)) +
    ggplot2::geom_bar(stat = "identity", color = "#777777") +
    ggplot2::ggtitle(title) +
    ggplot2::scale_fill_manual(values = c("tomato1", "springgreen2")) +
    ggplot2::geom_text(aes(label = label, y = valencia),
      position = "stack",
      size = 4.5, vjust = 2
    ) +
    ggplot2::theme_minimal() +
    custom_theme

  return(plot)
}

#' Plot Valence Timeline
#'
#' This function plots the sentiment valence in the time.
#'
plotValenceTimeline <- function(words) {
  aux <- words |>
    group_by(publishedAt) |>
    summarise(Positive = sum(positives), Negative = sum(negatives)) |>
    pivot_longer(c(Positive, Negative), names_to = "Valence", values_to = "Count")

  aux |>
    ggplot(aes(x = publishedAt, y = Count, color = Valence)) +
    geom_line(size = 1) +
    xlab("Publication date") +
    scale_y_continuous(name = "Words", limits = c(0, max(aux$Count)), breaks = 0:max(aux$Count)) +
    ggtitle("Words Valence in The Time") +
    theme_dark()
}
