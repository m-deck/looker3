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

docker pull $DOCKER_IMAGE
!(!(docker run -i --rm --name $CONTAINER_NAME -v $WORKSPACE:$DOCKER_WORKSPACE -w $DOCKER_WORKSPACE $DOCKER_IMAGE bash -c "/usr/bin/R -e 'library(bettertrace);a <- try(devtools::test()); quit(status = if (methods::is(a, \\\"try-error\\\") || sum(c(as.data.frame(a)\\$failed, as.data.frame(a)\\$error)) > 0) { 1 } else { 0 })'"))

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
