validate_response <- function(http_response) {

  # TODO: validate that the response is a request 
  # object with success status code.
  
  TRUE
}

extract_login_token <- function(login_response) {
  validate_response(login_response)

  # TODO: figure out how to extract the login token from this
  # httr:::content(login_response) 
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
