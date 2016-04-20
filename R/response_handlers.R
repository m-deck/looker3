validate_response <- function(http_response) {
  checkr::validate(httr:::status_code(http_response) %in% c("200", "202", "204")) 
  TRUE
}

extract_login_token <- function(login_response) {
  validate_response(login_response)
  httr:::content(login_response)$access_token
}


handle_logout_response <- function(logout_response) { 
  validate_response(logout_response)
}

extract_query_result <- function(query_response) {
  validate_respose(query_response)
  data_from_query <- httr:::content(query_response)
  recombinator::recombinator(data_from_query)
}

