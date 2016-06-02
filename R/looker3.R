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
#'
#' @return a data.frame containing the data returned by the query
#'
#' @export
looker3 <- function(model, view, fields,
             filters = list(), limit = 1000) {

  env_var_descriptions <- list(
    LOOKER_URL    = "API url",
    LOOKER_ID     = "client id",
    LOOKER_SECRET = "client secret"
  )

  looker_setup <- lapply(names(env_var_descriptions), function(name) {
    env_var <- Sys.getenv(name)
    if (env_var == "") {
      stop(paste0("Your environment variables are not set correctly. ",
        "please place your Looker 3.0 ", env_var_descriptions[[name]],
        " in the environment variable ", name, "."
      ))
    }
    env_var
  })

  names(looker_setup) <- names(env_var_descriptions)

  # model, view, and fields are required to perform a query
  if (missing(model) || !methods::is(model, "character") || length(model) != 1) {
   stop("`model` must be a character vector of length 1.")  
  }

  if (missing(view) || !methods::is(view, "character") || length(view) != 1) {
   stop("`view` must be a character vector of length 1.")  
  }

  if (missing(fields) || !(methods::is(fields, "character"))) {
    stop("`fields` must be a character vector.")  
  }


  # if user-specified filters as a character vector, reformat to a list
  if (!missing(filters) && is.character(filters)) {
    filters <- colon_split_to_list(filters) 
  }

  run_inline_query(looker_setup$LOOKER_URL, looker_setup$LOOKER_ID, looker_setup$LOOKER_SECRET,
    model, view, fields, filters, limit)
}


colon_split_to_list <- function(string) {
  colon_split <- strsplit(string, ": ")
  field_names <- lapply(colon_split, `[[`, 1)
  values <- lapply(colon_split, `[[`, 2)
  names(values) <- field_names
  values
}
