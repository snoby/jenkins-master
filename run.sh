#!/bin/bash

# This is for running on the docker host machine
#
app="jenkins_master"
if docker ps | awk -v app="app" 'NR>1{  ($(NF) == app )  }'; then
  printf "Stopping and removing %s \n" "$app"
  docker stop "$app" && docker rm -f "$app"
fi

docker run -d                                             \
           -v /var/repos/jenkins:/var/jenkins_home        \
           --restart=always                               \
           -p 8080                                        \
           -p "50000:50000"                               \
           --name=jenkins_master                          \
           -e VIRTUAL_HOST=jenkins.mattsnoby.com          \
           -e VIRTUAL_PORT=8080                           \
           iotapi322/jenkins_master


