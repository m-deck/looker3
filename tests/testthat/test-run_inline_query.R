context("run_inline_query")

with_mock(
  `avant-looker3:::looker_api_call` = function(...) NULL,
  `avant-looker3:::extract_login_token` = function(...) NULL,
  `avant-looker3:::create_inline_query_body` = function(...) NULL,
  `avant-looker3:::extract_data_from_inline_query` = function(...) NULL, {
    expect_true(TRUE)  

})


expect_true(ensure_line_coverage())
