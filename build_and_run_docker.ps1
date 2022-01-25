

# the path to an renv cache on the host machine
$RENV_PATHS_CACHE_HOST="/opt/local/renv/cache"

# the path to the cache within the container
$RENV_PATHS_CACHE_CONTAINER="/renv/cacheA"

# cleaning
docker image prune --force
# Build image
docker build . -t "news_sentiment"
# Run and bind to port 3838 
#docker run --rm -p 3838:3838 news_sentiment

# localhost:3838
# run the container with the host cache mounted in the container
docker run --rm -e "RENV_PATHS_CACHE=${$RENV_PATHS_CACHE_CONTAINER}" -v "${$RENV_PATHS_CACHE_HOST}:${$RENV_PATHS_CACHE_CONTAINER}" -p 3838:3838 news_sentiment