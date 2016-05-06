/* 
 * Job configuration specific to the https://github.com/avantcredit/looker3 
 * CI Tool: Jenkins, Job DSL plugin
 * Contacts: Oleksandr K. <oleksandr.kryshchenko@avant.com>
 */
class JenkinsCi {
    /*
     * Actual build step that's gonna run in the job config.
     * In case of R we just use a shell script.
     */
     static String build_step = '''\
#======================================
# Running container and main build step
#======================================

CONTAINER_NAME=$BUILD_TAG
DOCKER_IMAGE="de-docker.art.local/aa-r-avantformula:latest"

R="\`/usr/bin/R -e "
R=$R"\"download <- function(path, url, ...){"
R=$R"request <- httr::GET(url, ...);"
R=$R"httr::stop_for_status(request);"
R=$R"writeBin(httr::content(request, 'raw'), path);"
R=$R"path};"
R=$R"lockbox_tar <- tempfile(fileext = '.tar.gz');"
R=$R"lockbox_url <- 'https://github.com/robertzk/lockbox/archive/0.2.4.tar.gz';"
R=$R"download(lockbox_tar, lockbox_url);"
R=$R"install.packages(lockbox_tar, repos = NULL, type = 'source');"
R=$R"message(crayon::yellow('Loading safe stable changes...'));"
R=$R"lockbox::lockbox('lockfile.stable.yml');"
R=$R"library(bettertrace);"
R=$R"a <- try(devtools::test());"
R=$R"quit(status = if (methods::is(a, 'try-error') || sum(c(as.data.frame(a)\$failed, as.data.frame(a)\$error)) > 0) { 1} else { 0 })\"\`"

docker pull $DOCKER_IMAGE

!(!(docker run -i --rm --name $CONTAINER_NAME -v $WORKSPACE:$DOCKER_WORKSPACE -w $DOCKER_WORKSPACE $DOCKER_IMAGE bash -c "$R"))

echo DOCKER_RUN_EXIT_STATUS=$? > env.properties

echo "Exit status:" $DOCKER_RUN_EXIT_STATUS
'''
    /*
     * Whether to report build status to the GitHub.
     */
     static Boolean report_status = true
        
    /*
     * We checkout code form GitHub using ssh. For this a deployment key
     * should be installed on the repo settings and a user with credentials
     * has to be created in Jenkins. This is Jenkin's internal id for that user.
     */
     static String gh_key_id = '40629a7d-fc60-4d47-9618-5236dc56f477'
}
