#!/bin/bash


#export http_proxy=http://10.0.0.131:3128
#docker build --build-arg HTTP_PROXY=http://1.0.0.105:3128 -t jenkins .
docker build --build-arg=HTTP_PROXY=$http_proxy -t iotapi322/jenkins_master .
