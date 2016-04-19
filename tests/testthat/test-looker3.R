context("looker3")


fake_env_vars <- list(
  url    = "fake.looker.com:111/",
  id     = "fake_client",
  secret = "fake_secret"
)


withr::with_envvar(c(
  "LOOKER_URL"    = fake_env_vars$url,
  "LOOKER_ID"     = fake_env_vars$id,
  "LOOKER_SECRET" = fake_env_vars$secret
), {
  
  describe("handling missing env vars", {

    test_that("it stops if LOOKER_URL is missing", {
      withr::with_envvar(c("LOOKER_URL" = ""),
        expect_error(looker3(model = "look", view = "items", fields = "name"),
          "place your Looker 3.0 API url in the environment")
      )
    })

    test_that("it stops if LOOKER_ID is missing", {
      withr::with_envvar(c("LOOKER_ID" = ""),
        expect_error(looker3(model = "look", view = "items", fields = "name"),
          "place your Looker 3.0 client id in the environment")
      )
    })

    test_that("it stops if LOOKER_SECRET is missing", {
      withr::with_envvar(c("LOOKER_SECRET" = ""),
        expect_error(looker3(model = "look", view = "items", fields = "name"),
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
  
      args <- list(model = "look", view = "items",
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
