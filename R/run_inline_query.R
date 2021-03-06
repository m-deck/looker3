#' Run an inline query using the Looker 3.0 API.
#'
#' @param base_url character. The base url of the Looker server.
#' @param client_id character. Your client id.
#' @param client_secret character. Your client secret.
#' @param model character. The \code{model} parameter of the query.
#' @param view character. The \code{view} parameter of the query.
#' @param fields character. The \code{fields} parameter of the query.
#' @param filters named list. The names and entries of the list will
#' be converted into a hash table and passed as the \code{filters}
#' of the query.
#' @param limit numeric. The \code{limit} parameter of the query.
#'
#' @return a data.frame containing the data returned by the query.
#'
run_inline_query <- function(base_url, client_id, client_secret, 
                      model, view, fields, filters, 
                      limit = 1000, silent_read_csv) {


  # The API requires you to "log in" and obtain a session token
  # TODO: find a way to cache the session token, perhaps using memoise package?

  if (cached_token_is_invalid()) {
    login_response <- login_api_call(base_url, client_id, client_secret)
    put_new_token_in_cache(login_response)
  }
  
  inline_query_response <- query_api_call(base_url,
    model, view, fields, filters, limit) 

  extract_query_result(inline_query_response, silent_read_csv)
}
