is.successful_response <- function(response) {
  httr::status_code(response) %in% c("200", "201", "202", "204")
}


validate_response <- function(response) {
  if (is.successful_response(response)) { return(TRUE) }

  stop(paste0("The ", 
    gsub("_", " ", deparse(substitute(response))), 
    " of your Looker query was not a successful response.",
    "it returned a status code of ", 
    httr::status_code(response)
    )
  )
}

extract_login_token <- function(login_response) {
  validate_response(login_response)
  httr::content(login_response)$access_token
}


handle_logout_response <- function(logout_response) { 
  validate_response(logout_response)
}

extract_query_result <- function(query_response) {
  validate_response(query_response)
  data_from_query <- httr::content(query_response)
  utils::read.csv(text = data_from_query)
}

