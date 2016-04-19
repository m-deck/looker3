login_api_call <- function(base_url, client_id, client_secret) {
  full_url <- paste0(base_url, "api/3.0/login?client_id=", client_id, "&client_secret=", secret)
  httr::POST(url = full_url)
}

logout_api_call <- function(base_url, token) {
  full_url <- paste0(base_url, "api/3.0/logout")
  httr::DELETE(url = full_url, add_headers(Authorization = paste0("token ", token)))
}

query_api_call <- function(base_url, token, model, view, fields, filters, limit = 10, streaming = TRUE){
  full_url <- paste0(base_url, "api/3.0/queries/run/json")
  request_body <- list(model = model, view = view, fields = fields, filters = filters, limit, streaming)
  httr::POST(url = full_url, add_headers(Authorization = paste0("token ", token)),  body = request_body, encode = "json")
}
