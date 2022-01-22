
dataModule <- modules::module({

  modules::import("utils","read.table")
  modules::import("dplyr")
  
  
#' Get available countries
#'
#' Return the list of countries
#'
getAvailableCountries <- function() {
  countries <- utils::read.table("./data/countries",
                          header = TRUE,
                          sep = ",", encoding = "UTF-8"
  )
  api_countries <- utils::read.table("./data/api_countries",
                              header = TRUE,
                              sep = ",", encoding = "UTF-8"
  )
  countries$Code <- tolower(countries$Code)
  
  filtered <- countries %>%
    dplyr::inner_join(api_countries, by = "Code")
  
  countries <- filtered$Code
  names(countries) <- filtered$Name
  return(countries)
}

})