context("api calling helper functions")

with_mock(
  `httr::POST` = function(...) NULL,
  `httr::DELETE` = function(...) NULL, {

    describe("login_api_call",
      # TODO: write tests
      expect_true(TRUE)
    )

    describe("logout_api_call",
      # TODO: write tests
      expect_true(TRUE)
    )

    describe("query_api_call",
      # TODO: write tests
      expect_true(TRUE)
    )
})
