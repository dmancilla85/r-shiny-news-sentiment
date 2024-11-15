FROM rocker/r-base:latest
LABEL maintainer="USER <david.a.m@live.com>"
RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
	libxml2-dev \
    && rm -rf /var/lib/apt/lists/*


RUN echo "local(options(shiny.port = 3838, shiny.host = '0.0.0.0'))" > /usr/lib/R/etc/Rprofile.site
RUN addgroup --system app \
    && adduser --system --ingroup app app

ENV RENV_ACTIVATE_PROJECT=false 
ENV NEWS_API_TOKEN=f4a88e83555a4ffd91669835d38efedf
ENV RENV_VERSION=0.15.1
RUN R -e "install.packages('remotes', repos = c(CRAN = 'https://cloud.r-project.org'))"
RUN R -e "remotes::install_github('rstudio/renv@${RENV_VERSION}')"

WORKDIR /home/app
COPY . /home/app
RUN chown app:app -R /home/app
RUN R -s -e 'renv::restore()'

USER app
EXPOSE 3838

CMD ["R", "-e", "shiny::runApp('/home/app')"]