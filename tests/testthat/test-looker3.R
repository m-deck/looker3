context("looker3")


withr::with_envvars(c(
  "LOOKER_URL"    = "fake.looker.com:111/",
  "LOOKER_ID"     = "fake_client",
  "LOOKER_SECRET" = "fake_secret"
), {
  
  describe("handling missing env vars", {

    test_that("it stops if LOOKER_URL is missing", {
      withr::with_envvars(c("LOOKER_URL" = ""),
        expect_error(looker3(),
          "place your Looker 3.0 API url in the environment")
      )
    })

    test_that("it stops if LOOKER_ID is missing", {
      withr::with_envvars(c("LOOKER_ID" = ""),
        expect_error(looker3(),
          "place your Looker 3.0 client id in the environment")
      )
    })

    test_that("it stops if LOOKER_SECRET is missing", {
      withr::with_envvars(c("LOOKER_SECRET" = ""),
        expect_error(looker3(),
          "place your Looker 3.0 client secret in the environment")
      )
    })

  })


  test_that("it passes arguments to run_inline_query correctly", {

    with_mock(
      `looker3:::run_inline_query` = function(url, id, secret,
                                             model, view, fields, filters,
                                             limit, streaming) {
        list(url = url, id = id, secret = secret, model = model,
             view = view, fields = fields, filters = filters,
             limit = limit, streaming = streaming)
      }, {
  
      args <- list(model = "thelook", view = "inventory_items", 
        fields = c("category.name", "products.count"),
        filters = list(c("category.name", "socks")))
  
      expect_equal(do.call(looker3, args),
       c(list(url = fake_env_vars$url, id = fake_env_vars$id, secret = fake_env_vars$secret), 
         args,
         list(limit = 10, streaming = TRUE)))
      expect_equal(do.call(looker3, c(args, list(limit = 20, streaming = FALSE))),
       c(list(url = fake_env_vars$url, id = fake_env_vars$id, secret = fake_env_vars$secret), 
         args,
         list(limit = 20, streaming = FALSE)))
      })
  })


})
