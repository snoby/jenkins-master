#!/bin/bash


#export http_proxy=http://10.0.0.105:3128
#docker build --build-arg HTTP_PROXY=http://1.0.0.105:3128 -t jenkins .
docker build  -t snoby/jenkins_master .
