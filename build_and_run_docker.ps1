# cleaning
docker image prune --force
# Build image
docker build . -t "news_sentiment"
# Run and bind to port 3838 
docker run --rm -p 3838:3838 news_sentiment

# localhost:3838