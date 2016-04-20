context("response handling helper functions")

# TODO: create mock response objects.
fake_login_response <- list(status = "200", access_token = "FAKE_TOKEN") 
fake_logout_response <- NULL
fake_query_response <- NULL

test_that("helpers validate before processing responses", {
  with_mock(`looker3:::validate_response` = function(...) stop("valiate_response called"), {
      expect_error(extract_login_token(fake_login_response))  
      expect_error(handle_logout_response(fake_logout_response))  
      expect_error(extract_query_results(fake_query_response))  
  })
})

describe("processing successful responses", {
  with_mock(
  `httr:::status_code` = function(response) { response$status }, 
  `httr:::content` = function(response) { response$body }, {

    test_that("extract_login_token returns the access token", { 
      fake_login_response <- list(status = "200", body = list(access_token = "FAKE_TOKEN"))
      expect_equal(extract_login_token(fake_login_response),
                   "FAKE_TOKEN")
    })   
   
    test_that("handle_logout_response returns TRUE", {
      fake_logout_response <- list(status = "204")  
      expect_true(handle_logout_response(fake_logout_response))
    })
  
    test_that("extract_query_result returns a data frame", {
      fake_query_response <- list(status = "200", body = list(list("id", "first", "second"), list("a", "1", "2"), list("b", "10", "20")))  
      expect_equal(extract_query_result(fake_query_response),
        recombinator::recombinator(list(list("id", "first", "second"), list("a", "1", "2"), list("b", "10", "20"))))
    })
   
  })  
  
  
  
})
  
