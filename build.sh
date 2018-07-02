#!/bin/bash
set -xe
source version.env
VERSION="$GSD_JENKINS_VERSION"
CONTAINER_NAME="iotapi322/jenkins-master:${VERSION}"
docker build --build-arg JENKINS_VERSION="$JENKINS_VERSION" -t "${CONTAINER_NAME}" .
