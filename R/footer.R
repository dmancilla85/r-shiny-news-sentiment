
footerModule <- modules::module({
  
htmlLeft <-
  shiny::HTML(
    "<span id='footer-text'>Sentiment on News, David A. Mancilla, &copy; 2021. Based on syuzhet package and NRC EmoLex (saifmohammad.com/WebPages/NRC-Emotion-Lexicon.htm). Welcome ilustration designed by <a href='http://www.freepik.com'>stories / Freepik</a>.</span>"
  )

htmlRight <- shiny::HTML(
  "<span id='footer-links'>Find me in:    <a href='https://github.com/dmancilla85' target='_blank'><i class='fab fa-github-alt fa-2x'></i></a>      <a href='https://www.linkedin.com/in/dmancilla1/' target='_blank'><i class='fab fa-linkedin-in fa-2x'></i></a>     <a href='https://www.linkedin.com/in/dmancilla1/' target='_blank'><i class='fab fa-facebook-square fa-2x'></i></a></span>"
)

})