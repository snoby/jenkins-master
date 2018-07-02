# jenkins-master-docker
The Jenkins Master docker configuration

This is the Docker image that runs on jenkins-01.ccs.tropo.com, the jenkins home directory is a mounted volume.  The docker container is run as jenkins_tropo.gen.

## How to update the image
The image is derived from the official Jenkins/jenkins:2.1xx-slim image.  You can view the updated available base images on [dockerhub](https://hub.docker.com/r/jenkins/jenkins/tags/).
### How to update the jenkins base image
As an example we are using the 2.100-slim image.  If you wish to update the image adjust the value in the [version.env](version.env) file.  For instance to update the base image from 2.100-slim to 2.104-slim just change the `JENKINS_VERSION` field

```
#
# This is the version of the jenkins docker image that we inherit
#
export JENKINS_VERSION='2.100-slim'

#
# Bump this version when a change has been made to
# the build
#
export TROPO_VERSION='v1.4.4-'

export TROPO_JENKINS_VERSION="$TROPO_VERSION$JENKINS_VERSION"
```
If you have updated anything else in relation to the image bump the `TROPO_VERSION` field.  As you can see the actual version field of the Jenkins container is a concatenation of the Jenkins version and the tropo version.

### Build the image

After bumping the value in the file [version.env](version.env) just execute the command `build.sh`.

### Running the image
You can run the image by executing the commdn [run_jenkins_master.sh](run_jenkins_master.sh).  The version will automatically be updated for you.  However please review the file to understand how the jenkins container is expected to be run in production.

### Pushing the image

if you are statisfied with the result then push the image to the registry with the command `push.sh`. Note: You should have already logged into containers.cisco.com

## More advanced features.
There are more advanced things you *could* do to this deployment.  See the repository: https://github.com/foxylion/docker-jenkins which has examples of:
* how to setup jenkins to have a default user and password
* bypass the initial setup wizard


