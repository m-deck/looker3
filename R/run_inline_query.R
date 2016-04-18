#' Run an inline query using the Looker 3.0 API.
#'
#' @param base_url character. The base url of the Looker server.
#' @param client_id character. Your client id.
#' @param client_secret character. Your client secret.
#' @param model character. The \code{model} parameter of the query.
#' @param view character. The \code{view} parameter of the query.
#' @param fields character. The \code{fields} parameter of the query.
#' @param filters list. Each element of the list is a length 2 character vector,
#' each vector describing one of the \code{filters} of the query.
#' @param limit numeric. The \code{limit} parameter of the query.
#' @param streaming logical. Whether or not to use the \code{streaming} feature.
#'
#' @return a data.frame containing the data returned by the query.
#'
#' @example /dontrun{
#'   run_inline_query("http://abelrocks.looker.com:111/", "my_id", "my_secret", 
#'     model = "thelook", view = "inventory_items",
#'     fields = c("category.name", "products.count"),
#'     filters = list(c("category.name", "socks"))
#'   ) 
#' }
#'
run_inline_query <- function(base_url, client_id, client_secret, 
                      model, view, fields, filters, 
                      limit = 10, streaming = TRUE) {


  # The API requires you to "log in" and obtain a session token
  # TODO: find a way to cache the session token, perhaps using memoise package?
  login_response <- login_api_call(base_url, client_id, client_secret) 
  session_token  <- extract_login_token(login_response)

  # We need to log out of the session, regardless of its outcome.
  on.exit(
    logout_response <- logout_api_call(base_url, session_token)
    handle_logout_response(logout_response)
  )
  
  inline_query_response <- query_api_call(base_url, session_token,
    model, view, fields, filters, limit, streaming) 

  extract_query_result(inline_query_response)  
}
