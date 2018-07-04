#!/bin/bash
if [ -e version.env ]; then
  source version.env
else
  export GSD_JENKINS_VERSION=v'1.0.1-2.130-slim'
fi

MAX_CONT_MEM="8192"
NUM_OF_CPU=$(getconf _NPROCESSORS_ONLN)

#
# Documentation on this can be found here:
# https://jenkins.io/blog/2016/11/21/gc-tuning/
J_GC_OPS="-XX:+UseG1GC -XX:+ExplicitGCInvokesConcurrent -XX:+ParallelRefProcEnabled -XX:+UseStringDeduplication -XX:+UnlockExperimentalVMOptions -XX:G1NewSizePercent=20 -XX:+UnlockDiagnosticVMOptions -XX:G1SummarizeRSetStatsPeriod=1 "

#Take all the memory we are giving the Container and slice of 1GB
J_MAX=$(( MAX_CONT_MEM-1024 ))
# Now set the minmum Heap to 1/3 of what our Max Heap will be
J_MIN=$((J_MAX/3))
# These are the memory options min and max java heap
J_MEM_OPS="-Xms${J_MIN}m -Xmx${J_MAX}m"
# Concatenate everything together
J_OPS="${J_GC_OPS} ${J_MEM_OPS}"


#
# Select how many CPU's to use
#
if [ "$NUM_OF_CPU" -ge "8" ]; then
  JENKINS_CPU=$NUM_OF_CPU/2
else
  JENKINS_CPU=6
fi
# This is for running on the docker host machine
# If it's running then stop it.
app="jenkins_master"
if docker ps | awk -v app="app" 'NR>1{  ($(NF) == app )  }'; then
  printf "Stopping and removing %s \n" "$app"
  docker stop "$app" && docker rm -f "$app"
fi



docker run -d                                             \
           -v /var/repos/jenkins:/var/jenkins_home        \
           -v /var/run/docker.sock:/var/run/docker.sock   \
           --restart=always                               \
           --privileged                                   \
           -p 8080                                        \
           -p "50000:50000"                               \
           --name=jenkins_master                          \
           -e "JAVA_OPTS=${J_OPS}"                        \
           -e VIRTUAL_HOST=jenkins.mattsnoby.com          \
           -e VIRTUAL_PORT=8080                           \
           -e LETSENCRYPT_HOST=jenkins.mattsnoby.com      \
           -e LETSENCRYPT_EMAIL=matt.snoby@icloud.com     \
           "--memory=${MAX_CONT_MEM}m"                    \
           "--cpus=${JENKINS_CPU}"                        \
           "iotapi322/jenkins-master:${GSD_JENKINS_VERSION}"


