context("response handling helper functions")

# TODO: create mock response objects.
fake_successful_response <- NULL
fake_failed_response <- NULL
fake_login_response <- NULL
fake_logout_response <- NULL
fake_query_response <- NULL

describe("validate_response", {
  test_that("it errors on a failed response", {
  # TODO: write test
  })
  test_that("it returns TRUE on a successful response", {
 # TODO: write test 
  })
})

describe("extract_login_token", {
  test_that("it calls validate_response", {
    with_mock(`avant-looker3:::validate_response` = function(...) stop("valiate_response called"), {
      expect_error(extract_login_token(fake_login_response))  
    })
  })
  test_that("it extracts the login token from the response", {
#   expect_equal(extract_login_token(fake_login_response), "fake_token")  
  })
})

describe("handle_logout_response", {
  test_that("it calls validate_response", {
    with_mock(`avant-looker3:::validate_response` = function(...) stop("valiate_response called"), {
      expect_error(handle_logout_response(fake_logout_response))  
    })
  })
  test_that("it returns TRUE on a successful logout attempt", {
#   expect_identical(handle_logout_response(fake_logout_response), "logout successful")  
  })
})

describe("extract_query_results", {
  test_that("it calls validate_response", {
    with_mock(`avant-looker3:::validate_response` = function(...) stop("valiate_response called"), {
      expect_error(extract_query_results(fake_query_response))  
    })
  })
  test_that("it returns the data as a data frame on a successful query response", {
#      expect_equal(extract_query_results(fake_query_response),
#                   data.frame(a = c(1,2), b = c(10,20)))  
  })
})

