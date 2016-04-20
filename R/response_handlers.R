validate_response <- function(http_response) {

  # TODO: validate that the response is a request 
  # object with success status code.
  httr:::content(http_response) %in% c("200", "202", "204")  
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
  validate_response(query_response)

  # TODO: figure out how to extract the data
  # output <- httr:::content(query_response)

  # TODO: verify that the recombinator input is valid


  # TODO: figure out how/if recombination is needed 
  # recombinator::recombinator(output)

}
