#!/bin/bash
app="jenkins_master"
if docker ps | awk -v app="app" 'NR>1{  ($(NF) == app )  }'; then
  printf "Stopping and removing %s \n" "$app"
  docker stop "$app" && docker rm -f "$app"
fi

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
           iotapi322/jenkins_master


#-v "/var/repos/jenkins:/var/jenkins_home"      \

          # --cpu-shares 2048                               \
          # -m 4096                                        \


