
login_api_call <- function(base_url, client_id, client_secret) {
  login_url <- paste0(base_url, "api/3.0/login?client_id=", client_id, 
                "&client_secret=", client_secret)
  httr::POST(login_url)
}

logout_api_call <- function(base_url, token) {
  logout_url <- paste0(base_url, "api/3.0/logout")
  httr::DELETE(logout_url, 
    httr::add_headers(Authorization = paste0("token ", token)))
}

query_api_call <- function(base_url, token, model, view, fields, filters, 
                    limit = 10){
  query_url <- paste0(base_url, "api/3.0/queries/run/csv")
  query_body <- list(model = model, view = view, fields = I(fields),
                  filters = filters, limit = limit)
  if (length(filters) == 0) { query_body$filters <- NULL }

  httr::with_config(httr::timeout(7200), # forcibly specify the timeout option for now
    httr::POST(url = query_url,
      httr::add_headers(Authorization = paste0("token ", token)),
      body = query_body, encode = "json")
  )
}
