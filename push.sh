#!/bin/bash

#
# Pass in the version tag you want me to push
#
set -xe
source version.env


CONTAINER_VERSION="$GSD_JENKINS_VERSION"
if [ -z "$CONTAINER_VERSION"  ]; then echo "I need the version of the container you want me to push"; fi


#
# This assumes you have already logged in...
#
docker push "iotapi322/jenkins-master:${CONTAINER_VERSION}"
