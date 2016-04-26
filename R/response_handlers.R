validate_response <- function(http_response, step_name) {
  status_code <- httr::status_code(http_response)

  if (status_code %in% c("200", "201", "202", "204")) {
    return(TRUE)  
  }

  stop("The ", step_name, "of your Looker query did not succeed. ",
    "it exited with a status code of ", status_code) 
}

extract_login_token <- function(login_response) {
  validate_response(login_response, "login")
  httr::content(login_response)$access_token
}


handle_logout_response <- function(logout_response) { 
  validate_response(logout_response, "logout")
}

extract_query_result <- function(query_response) {
  validate_response(query_response, "inline_query")
  data_from_query <- httr::content(query_response)
  utils::read.csv(text = data_from_query)
}

