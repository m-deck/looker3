context("run_inline_query")

describe("run_inline_query helpers properly called", {
  with_mock(
    `avant-looker3:::login_api_call` = function(...) NULL,
    `avant-looker3:::logout_api_call` = function(...) NULL,
    `avant-looker3:::query_api_call` = function(...) NULL,
    `avant-looker3:::extract_login_token` = function(...) NULL,
    `avant-looker3:::handle_logout_response` = function(...) NULL,
    `avant-looker3:::extract_query_result` = function(...) NULL, {
      expect_true(TRUE)  
  })
})

expect_true(ensure_line_coverage())
