context("response handling helper functions")

fake_login_response  <- list(status = "200", 
                            body = list(access_token = "FAKE_TOKEN"))
fake_logout_response <- list(status = "204")  
fake_query_response  <- list(status = "200", 
                             body = "ID, VALUE \n 1, 2")
fake_query_failure   <- list(status = "500")
fake_logout_failure  <- list(status = "500")


with_mock(`httr::status_code` = function(x) x$status, {
  test_that("validate_response errors with step name and status code", {
    expect_error(validate_response(fake_query_failure),
      "The fake query failure of your Looker query")
    expect_error(validate_response(fake_query_failure),
      "returned a status code of 500")
   })
})


test_that("helpers validate before processing responses", {
  with_mock(
    `looker3:::validate_response` = function(http_object) {
      stop("valiate_response called")
    }, {
      expect_error(extract_login_token(fake_login_response))
      expect_error(handle_logout_response(fake_logout_response))
      expect_error(extract_query_result(fake_query_response))
  })
})

describe("processing successful responses", {
  with_mock(
  `httr::status_code` = function(response) { response$status }, 
  `httr::content` = function(response) { response$body }, {
    test_that("handle_logout_response returns TRUE", {
      expect_true(handle_logout_response(fake_logout_response))
    })
    test_that("extract_query_result returns a data frame", {
      result <- extract_query_result(fake_query_response)
      # readr::read_csv adds extra classes,
      # so let's remove them before making our comparison
      class(result) <- "data.frame"
      expect_equal(result, data.frame(ID = 1, VALUE = 2))
    })
  })  
})
  
