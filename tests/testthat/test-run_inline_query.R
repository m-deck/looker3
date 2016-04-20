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
    `looker3:::query_api_call` = function(...) NULL,
    `looker3:::extract_login_token` = function(...) NULL,
    `looker3:::handle_logout_response` = function(...) NULL,
    `looker3:::extract_query_result` = function(...) NULL, {

      test_that("login_api_call receives the base_url, client_id, and secret", {
        with_mock(`looker3:::login_api_call` = function(base_url, client_id, client_secret) {
          stop(paste("login_api_call:", base_url, client_id, client_secret))  
        }, {
          expect_error(do.call(run_inline_query, args),
          "login_api_call: fake.looker.com/ fake_client fake_secret")  
        })  
      })

      test_that("extract_login_token receives the output of login_api_call", {
        with_mock(
          `looker3:::login_api_call` = function(...) "response received",
          `looker3:::extract_login_token` = function(login_response) {
            stop(paste0("extract_login_token called: ", login_response))  
          }, {
            expect_error(do.call(run_inline_query, args),
            "extract_login_token called: response received")  
        })  
      })

      test_that("query_api_call receives its args, including token", {

        with_mock(
          `looker3:::extract_login_token` = function(...) "fake_token",
          `looker3:::query_api_call` = function(base_url, token, model, view, fields, filters, limit) {
            actual_inputs <- list(base_url = base_url, token = token, model = model, view = view, fields = fields,
                           filters = filters, limit = limit)
            expected_inputs <- list(base_url = args$base_url, token = "fake_token", model = args$model, view = args$view,
                            fields = args$fields, filters = args$filters, limit = 10) 
            if (identical(actual_inputs, expected_inputs)) {
              stop("query_api_call called correctly") 
            } 
           stop("query_api_call with incorrect inputs") 
          }, {
            expect_error(do.call(run_inline_query, args), "query_api_call called correctly")
          })
          
        with_mock(
          `looker3:::extract_login_token` = function(...) "fake_token",
          `looker3:::query_api_call` = function(base_url, token, model, view, fields, filters, limit) {
            actual_inputs <- list(base_url = base_url, token = token, model = model, view = view, fields = fields,
                           filters = filters, limit = limit)
            expected_inputs <- list(base_url = args$base_url, token = "fake_token", model = args$model, view = args$view,
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
          `looker3:::extract_query_result` = function(inline_query_response) {
            stop(paste0("extract_query_result called: "), inline_query_response)  
          }, {
            expect_error(do.call(run_inline_query, args), 
              "extract_query_result called: response received")  
        }) 
      })

      test_that("logout_api_call receives the base_url and the token", {
        with_mock(
          `looker3:::extract_login_token` = function(...) "fake_token", 
          `looker3:::logout_api_call` = function(base_url, session_token) {
            stop(paste("logout_api_call:", base_url, session_token))
          }, {
            expect_error(do.call(run_inline_query, args), 
              "logout_api_call: fake.looker.com/ fake_token")
        })
      })

      test_that("handle_logout_response recieves the output of logout_api_call", {
        with_mock(
          `looker3:::logout_api_call` = function(...) "response received",
          `looker3:::handle_logout_response` = function(logout_response) {
          stop(paste0("handle_logout_response called: ", logout_response))
          }, {
            expect_error(do.call(run_inline_query, args), 
              "handle_logout_response called: response received") 
        })  
      })
  })
})


expect_true(ensure_line_coverage())
