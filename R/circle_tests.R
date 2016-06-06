library(bettertrace)
library(checkr)


# Mounted under root dir in the docker container.
devtools::install("/looker3") 

tryCatch({
    a <- as.data.frame(devtools::test())
    st <- any(a$error | a$failed)
}, error = function(e) {
    dput(e)
    q(save="no", status = 1)
})

tryCatch({
    library(covr)
    codecov()
}, error = function (e) {
    dput(e)
    q(save = "no")
})

q(save="no", status = st)
