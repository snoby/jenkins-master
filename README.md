# jenkins-master
Jenkins Master that supports spinning up Jenkins slaves in docker containers

run build.sh to build.

I run this setup at home, you can see the exact start commands tha I use to start up the container with in the run.sh  cmd.

Once you start the container with a volume mount you can install any plugins that you want and even if you update this
container and mount at the previous volume mount you will bring in your previously downloaded plugins.  Basically updating this
container just updates the version of Jenkins that you are running.  All your configs are mounted  from your home directory in the shared
volume.  See the dockerhub description of this here:


https://hub.docker.com/_/jenkins/



