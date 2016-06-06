context("api calling helper functions")

with_mock(
  `httr::POST` = function(...) NULL,
  `httr::DELETE` = function(...) NULL, 
  `httr::add_headers` = function(Authorization) paste0("Authorization is ", Authorization), {

    test_that("login_api_call passes url to httr::POST", {
      with_mock(`httr::POST` = function(url) {
          identical(url,"https://fake.looker.com:111/api/3.0/login?client_id=FAKE_ID&client_secret=FAKE_SECRET")
        }, {
          expect_true(login_api_call("https://fake.looker.com:111/", 
                        "FAKE_ID", "FAKE_SECRET"))
      })
    })

    with_mock(
    `looker3:::cached_token_is_invalid` = function(...) { FALSE },
    `httr::POST` = function(url, header, body, encode) {
      list(url = url, header = header, body = body)  
    }, {
      args <- list(base_url = "https://fake.looker.com:111/",
        model = "look", view = "items", 
        fields = c("category.name", "products.count"), 
        filters = list(c("category.name", "socks")))

      token_cache$set("token", list(token = "FAKE_TOKEN"))

      test_that("query_api_call passes url to httr::POST", {
      expect_identical(
        do.call(query_api_call, args)$url,
        "https://fake.looker.com:111/api/3.0/queries/run/csv")
      })

      test_that("query_api_call passes token to httr::POST", {
      expect_identical(
        do.call(query_api_call, args)$header,
          "Authorization is token FAKE_TOKEN")
      })
    
      test_that("query_api_call passes body to httr::POST", {
      expect_equal(
        do.call(query_api_call, args)$body,
        list(model = args$model, view = args$view, fields = I(args$fields),
             filters = args$filters, limit = 1000))
      })

      test_that("query_api_call passes user-specified limit to httr::POST", {
      expect_equal(
        do.call(query_api_call, c(args, list(limit = 20)))$body,
        list(model = args$model, view = args$view, fields = I(args$fields),
             filters = args$filters, limit = 20))
      })

    })

})
