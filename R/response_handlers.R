cached_token_is_invalid <- function() {
  if (!token_cache$exists("token")) { return(TRUE) }
  expiration_date <- token_cache$get("token")$expires_in
  is.null(expiration_date) || methods::is(expiration_date, "POSIXt") || i
    (expiration_date < Sys.time())
}

is.successful_response <- function(response) {
  httr::status_code(response) %in% c("200", "201", "202", "204")
}

validate_response <- function(response) {
  if (is.successful_response(response)) { return(TRUE) }

  query_type  <- deparse(substitute(response))
  status_code <- httr::status_code(response)

  stop(paste("The",
    gsub("_", " ", deparse(substitute(response))),
    "of your Looker query was not a successful response.",
    "It returned a status code of",
    httr::status_code(response)
    )
  )
}

put_new_token_in_cache <- function(login_response) {
  validate_response(login_response)
  token_cache$set("token", list(
    token      = httr::content(login_response)$access_token,
    # avoid token expiration during code execution
    expires_in = Sys.time() + httr::content(login_response)$expires_in - 1 
  ))
}


handle_logout_response <- function(logout_response) { 
  validate_response(logout_response)
}

extract_query_result <- function(query_response) {
  validate_response(query_response)
  data_from_query <- httr::content(query_response)
  if (grepl("^Error:", data_from_query)) {
    # assume that the query errored quietly and that data_from_query is an error message.
    stop("Looker returned the following error message:\n", as.character(data_from_query))
  }
  readr::read_csv(data_from_query)
}

