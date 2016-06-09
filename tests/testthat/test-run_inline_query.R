context("run_inline_query")

args <- list(
  base_url = "fake.looker.com/",
  client_id = "fake_client",
  client_secret = "fake_secret",
  model = "fake_model",
  view = "fake_view",
  fields = c("fake", "field"),
  filters = list(c("fake.name", "filtered"))
)

describe("run_inline_query helpers called with the corresponding inputs", {
  with_mock(
    `looker3:::login_api_call` = function(...) NULL,
    `looker3:::logout_api_call` = function(...) NULL,
    `looker3:::cached_token_is_invalid` = function(...) FALSE,
    `looker3:::query_api_call` = function(...) NULL,
    `looker3:::handle_logout_response` = function(...) NULL,
    `looker3:::extract_query_result` = function(...) NULL, {

      test_that("login_api_call called if cached token is invalid", {
        with_mock(
          `looker3:::login_api_call` = function(base_url, client_id, client_secret) {
            stop(paste("login_api_call:", base_url, client_id, client_secret))  
          },
          `looker3:::cached_token_is_invalid` = function(...) { TRUE }, {
            expect_error(do.call(run_inline_query, args),
              "login_api_call: fake.looker.com/ fake_client fake_secret")  
        })  
      })

      test_that("login procedure bypassed if cached token is valid", {
        with_mock(
          `looker3:::login_api_call` = function(...) {
            stop("stopped by login_api_call")
          },
          `looker3:::put_new_token_in_cache` = function(...) {
            stop("stopped by put_new_token_in_cache")
          },
          `looker3:::query_api_call` = function(...) {
            stop("bypassed token caching")
          }, {
            expect_error(do.call(run_inline_query, args),
              "bypassed token caching")
        })
      })

      test_that("query_api_call receives its args, including token", {

        with_mock(
          `looker3:::query_api_call` = function(base_url, model, view, fields, filters, limit) {
            actual_inputs <- list(base_url = base_url, model = model, view = view, fields = fields,
                           filters = filters, limit = limit)
            expected_inputs <- list(base_url = args$base_url, model = args$model, view = args$view,
                            fields = args$fields, filters = args$filters, limit = 1000) 
            if (identical(actual_inputs, expected_inputs)) {
              stop("query_api_call called correctly") 
            } 
           stop("query_api_call with incorrect inputs") 
          }, {
            expect_error(do.call(run_inline_query, args), "query_api_call called correctly")
          })
          
        with_mock(
          `looker3:::query_api_call` = function(base_url, model, view, fields, filters, limit) {
            actual_inputs <- list(base_url = base_url, model = model, view = view, fields = fields,
                           filters = filters, limit = limit)
            expected_inputs <- list(base_url = args$base_url, model = args$model, view = args$view,
                            fields = args$fields, filters = args$filters, limit = 20) 
            if (identical(actual_inputs, expected_inputs)) {
              stop("query_api_call called correctly") 
            } 
            stop("failure")
          }, {
            expect_error(do.call(run_inline_query, c(args, list(limit = 20)), "query_api_call called correctly"))
        })
      })  
      
      test_that("extract_query_result receives the output of query_api_call", {
        with_mock(
          `looker3:::query_api_call` = function(...) "response received", 
          `looker3:::extract_query_result` = function(inline_query_response, ...) {
            stop(paste0("extract_query_result called: "), inline_query_response)  
          }, {
            expect_error(do.call(run_inline_query, args), 
              "extract_query_result called: response received")  
        }) 
      })
  })
})


expect_true(ensure_line_coverage())
