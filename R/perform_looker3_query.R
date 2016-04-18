#' Pull data from Looker.
#'
#' This function assumes that you have set the environment
#' variables \code{LOOKER_URL}, \code{LOOKER_ID}, and 
#' \code{LOOKER_SECRET}.
#'
#' The function will not allow the query to proceed unless you specify
#' a model, a view, and at least one field.
#'
#' @param model character. The \code{model} parameter of the query.
#' @param view character. The \code{view} parameter of the query.
#' @param fields character. The \code{fields} parameter of the query.
#' @param filters list. Each element of the list is a length 2 character vector,
#' each vector describing one of the \code{filters} of the query.
#' @param limit numeric. The \code{limit} parameter of the query.
#' @param streaming logical. Whether or not to use the \code{streaming} feature.
#'
#' @return a data.frame containing the data returned by the query
#'
#' @example /dontrun{
#'   perform_looker3_query(model = "thelook", view = "inventory_items",
#'     fields = c("category.name", "products.count"),
#'     filters = list(c("category.name", "socks"))
#'   )
#' }
#' 
#' @export
perform_looker3_query <- function(model = NULL, view = NULL, fields = NULL, 
                           filters = list(), limit = 10, streaming = TRUE) {

  env_var_names <- c("LOOKER_URL", "LOOKER_ID", "LOOKER_SECRET") 
  env_var_descriptions <- c("API url", "client id", "client secret")

  looker_setup <- Map(function(name, description) {
    env_var <- Sys.getenv(name)
    if (env_var == "") {
      stop(paste0("Your environment variables are not set correctly. ",
      "please place your Looker 3.0 ", description, " in the environment ",
      "varialbe ", name))  
    }  
    env_var
  }, env_var_names, env_var_descriptions)

  names(looker_setup) <- c("url", "id", "secret")
  
  # model, view, and fields are required to perform a query
  checkr::validate(model %is% simple_string, view %is% simple_string,
                   is.character(fields))
  
  run_inline_query(looker_setup$url, looker_setup$id, looker_setup$secret, 
    model, view, fields, filters, limit, streaming)
}
