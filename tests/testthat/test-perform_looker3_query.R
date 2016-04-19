context("perform_looker3_query")

# Temporarily store the testing environment's env vars in R, 
# to restore them when exiting tests
existing_env_vars <- list(
  url    = Sys.getenv("LOOKER_URL"),
  id     = Sys.getenv("LOOKER_ID"),
  secret = Sys.getenv("LOOKER_SECRET")
)

fake_env_vars <- list(
  url    = "fake.looker.com:111/",
  id     = "fake_client",
  secret = "fake_secret" 
)

unstub_env_vars <- function() {
  Sys.setenv(
    LOOKER_URL    = existing_env_vars$url,
    LOOKER_ID     = existing_env_vars$id,
    LOOKER_SECRET = existing_env_vars$secret
  )  
}

stub_env_vars <- function() {
  Sys.setenv(
    LOOKER_URL    = fake_env_vars$url,
    LOOKER_ID     = fake_env_vars$id,
    LOOKER_SECRET = fake_env_vars$secret
  )  
}

describe("handling missing env vars", {
  
  stub_env_vars()
  on.exit(unstub_env_vars())

  test_that("it stops if LOOKER_URL is missing", {
    Sys.setenv(LOOKER_URL = "") # mocking an env var that has not been set
    expect_error(perform_looker3_query(),
      "place your Looker 3.0 API url in the environment")  
    Sys.setenv(LOOKER_URL = "fake.looker.com:111/")
  })
  
  test_that("it stops if LOOKER_ID is missing", {
    Sys.setenv(LOOKER_ID = "")  
    expect_error(perform_looker3_query(),
      "place your Looker 3.0 client id in the environment")
    Sys.setenv(LOOKER_ID = "fake_client")
  })
  
  test_that("it stops if LOOKER_SECRET is missing", {
    Sys.setenv(LOOKER_SECRET = "")
    expect_error(perform_looker3_query(),
      "place your Looker 3.0 client secret in the environment")
  })
  
})


test_that("it passes arguments to run_inline_query correctly", {
  
  stub_env_vars()
  on.exit(unstub_env_vars())

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
      
    expect_equal(do.call(perform_looker3_query, args),
     c(list(url = fake_env_vars$url, id = fake_env_vars$id, secret = fake_env_vars$secret), 
       args,
       list(limit = 10, streaming = TRUE)))
    expect_equal(do.call(perform_looker3_query, c(args, list(limit = 20, streaming = FALSE))),
     c(list(url = fake_env_vars$url, id = fake_env_vars$id, secret = fake_env_vars$secret), 
       args,
       list(limit = 20, streaming = FALSE)))
    })
})


