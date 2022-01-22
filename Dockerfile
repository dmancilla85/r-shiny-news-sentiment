FROM rocker/r-base:latest
LABEL maintainer="USER <david.a.m@live.com>"
RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
    && rm -rf /var/lib/apt/lists/*
RUN install.r shiny
RUN install.r renv
RUN install.r shinydashboard
RUN install.r DT
RUN install.r shinydashboardPlus
RUN install.r shinybusy
RUN install.r tm
RUN install.r shiny.i18n
RUN install.r modules
RUN install.r syuzhet
RUN install.r shiny
RUN install.r shinycustomloader
RUN install.r stringr
RUN install.r future
RUN install.r dplyr
RUN install.r tidyr
RUN install.r ggplot2
RUN install.r jsonlite
RUN install.r request
RUN install.r urltools

RUN echo "local(options(shiny.port = 3838, shiny.host = '0.0.0.0'))" > /usr/lib/R/etc/Rprofile.site
RUN addgroup --system app \
    && adduser --system --ingroup app app

ENV NEWS_API_TOKEN=f4a88e83555a4ffd91669835d38efedf

WORKDIR /home/app
COPY . /home/app
RUN chown app:app -R /home/app
USER app
EXPOSE 3838

CMD ["R", "-e", "shiny::runApp('/home/app')"]