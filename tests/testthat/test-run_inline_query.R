context("run_inline_query")

describe("run_inline_query helpers called with the corresponding inputs", {
  with_mock(
    `avant-looker3:::login_api_call` = function(...) NULL,
    `avant-looker3:::logout_api_call` = function(...) NULL,
    `avant-looker3:::query_api_call` = function(...) NULL,
    `avant-looker3:::extract_login_token` = function(...) NULL,
    `avant-looker3:::handle_logout_response` = function(...) NULL,
    `avant-looker3:::extract_query_result` = function(...) NULL, {
# TODO: write tests, unmocking the helpers one or two at a time.
  })
})


expect_true(ensure_line_coverage())
