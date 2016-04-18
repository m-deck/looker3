context("run_inline_query")

args <- list(
  base_url = "fake.looker.com/",
  client_id = "fake_client",
  client_secret = "fake_secret",
  model = "fake_model",
  view = "fake_view",
  filters = list(c("fake.name", "filtered")),
  limit = 7
)

describe("run_inline_query helpers called with the corresponding inputs", {
  with_mock(
    `avant-looker3:::login_api_call` = function(...) NULL,
    `avant-looker3:::logout_api_call` = function(...) NULL,
    `avant-looker3:::query_api_call` = function(...) NULL,
    `avant-looker3:::extract_login_token` = function(...) NULL,
    `avant-looker3:::handle_logout_response` = function(...) NULL,
    `avant-looker3:::extract_query_result` = function(...) NULL, {

      test_that("login_api_call receives the base_url, client_id, and secret", {
        with_mock(`avant-looker3:::login_api_call` = function(base_url, client_id, client_secret) {
          stop(paste("login_api_call:", base_url, client_id, client_secret))  
        }, {
          expect_error(do.call(run_inline_query, args),
          "login_api_call: fake.looker.com/ fake_client fake_secret")  
        })  
      })

      test_that("extract_login_token receives the output of login_api_call", {
        with_mock(
          `avant-looker3:::login_api_call` = function(...) "response received"
          `avant-looker3:::extract_login_token` = function(login_response) {
            stop(paste0("extract_login_token called: ", login_response))  
          }, {
            expect_error(do.call(run_inline_query, args),
            "extract_login_token called: response received")  
        })  
      })

      test_that("query_api_call receives its args, including streaming and token", {

        with_mock(
          `avant-looker3:::extract_login_token` = function(...) "fake_token",
          `avant-looker3:::query_api_call` = function(base_url, token, model, view, fields, filters, limit, streaming) {
            inputs <- list(base_url = base_url, token = token, model = model, view = view, fields = fields,
                           filters = filters, limit = limit, streaming = streaming)
            if inputs == c(args, list(streaming = TRUE, token = "fake_token"))) { stop("query_api_called correctly") } 
            stop("failure")
          }, {
            expect_error(do.call(run_inline_query, args), "query_api_called correctly")
          })
        })  

        with_mock(
          `avant-looker3:::extract_login_token` = function(...) "fake_token",
          `avant-looker3:::query_api_call` = function(base_url, token, model, view, fields, filters, limit, streaming) {
            inputs <- list(base_url = base_url, token = token, model = model, view = view, fields = fields,
                           filters = filters, limit = limit, streaming = streaming)
            if inputs == c(args, list(streaming = TRUE, token = "fake_token"))) { stop("query_api_called correctly") } 
            stop("failure")
          }, {
            expect_error(do.call(run_inline_query, c(args, list(streaming = FALSE)), "query_api_called correctly")
          })
        })  
  
      })

      test_that("extract_query_result receives the output of query_api_call", {
        with_mock(
          `avant-looker3:::query_api_call` = function(...) "response received", 
          `avant-looker3:::extract_query_result` = function(inline_query_response) {
            stop(paste0("extract_query_result called: "), inline_query_response)  
          }, {
            expect_error(do.call(run_inline_query, args), 
              "extract_query_result called: response received")  
        }) 
      })

      test_that("logout_api_call receives the base_url and the token", {
        with_mock(
          `avant-looker3:::extract_login_token` = function(...) "fake_token", 
          `avant-looker3:::logout_api_call` = function(base_url, session_token) {
            stop(paste("logout_api_call:", base_url, session_token))
          }, {
            expect_error(do.call(run_inline_query, args), 
              "logout_api_call: fake.looker.com/ fake_token")
        })
      })

      test_that("handle_logout_response recieves the output of logout_api_call", {
        with_mock(
          `avant-looker3:::logout_api_call` = function(...) "response received",
          `avant-looker3:::handle_logout_response` = function(logout_response) {
          stop(paste0("handle_logout_response called: ", logout_response))
          }, {
            expect_error(do.call(run_inline_query, args), 
              "handle_logout_response called: response received") 
        })  
      })
  })
})


expect_true(ensure_line_coverage())
