#!/bin/bash
set -x

#
# Start apt-cacher mirror
#
docker run -d                                             \
           -p 8080                                        \
           -p "50000:50000"                               \
           --name=jenkins_master                          \
           --label traefik.port=8080                      \
           --label traefik.enable=true                    \
           --label traefik.frontend.passHostHeader=true   \
           snoby/jenkins_master


#-v "/var/repos/jenkins:/var/jenkins_home"      \

          # --cpu-shares 2048                               \
          # -m 4096                                        \


