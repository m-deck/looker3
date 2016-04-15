
run_inline_query <- function(base_url, id, secret, model, view, fields, filters, limit) {

  # need to enforce required values before proceeding

  # The API requires you to "log in" and obtain a session token
  login_response <- looker_api_call(method = "POST", base_url = base_url, path = "/login", url = paste0("?client_id=", id, "&client_secret=", secret)
  session_token <- extract_login_token(login_response)

  # We need to log out of the session, regardless of its outcome.
  on.exit(
    looker_api_call("DELETE", base_url, "/logout", token = session_token)
  )
  
  # Required parameters are model, view, and fields.
  # Optional parameters are filters and limits (please use limits while experimenting)
  # We won't implement the sort parameter, please do your sorting on the R-side! 
  inline_query_response <- looker_api_call(method = "POST", base_url = base_url, path = "queries/run/json", 
    body = create_inline_query_body(model = model, view = view, fields = fields, filters = filters, limit = limit)) 
  extract_data_from_inline_query(inline_query_response)  
}
