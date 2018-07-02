ARG JENKINS_VERSION
FROM jenkins/jenkins:$JENKINS_VERSION
# I'm specifically NOT using the alpine image version


ENV DOCKER_BUCKET get.docker.com
ENV DOCKER_VERSION 1.12.1
ENV DOCKER_SHA256 05ceec7fd937e1416e5dce12b0b6e1c655907d349d52574319a1e875077ccb79

#
# Install docker
#
USER root
RUN set -x \
	&& curl -fSL "https://${DOCKER_BUCKET}/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz" -o docker.tgz \
	&& echo "${DOCKER_SHA256} *docker.tgz" | sha256sum -c - \
	&& tar -xzvf docker.tgz \
	&& mv docker/* /usr/local/bin/ \
	&& rmdir docker \
	&& rm docker.tgz \
	&& docker -v

RUN apt-get update && apt-get install -y \
             subversion   \
             curl         \
             vim          \
             procps       \
             git

ENV JENKINS_HOME "/var/jenkins_home"
ENV JENKINS_HOME_PLUGINS "/usr/share/jenkins/ref/plugins"

RUN /usr/local/bin/install-plugins.sh \
        build-pipeline-plugin         \
        cloudbees-folder              \
        dashboard-view                \
        gradle                        \
        job-dsl                       \
        plugin-usage-plugin           \
        build-flow-plugin             \
        buildgraph-view               \
        build-metrics                 \
        build-timeout                 \
        claim                         \
        config-file-provider          \
        configurationslicing          \
        console-column-plugin         \
        ansicolor                     \
        greenballs                    \
        htmlpublisher                 \
        credentials                   \
        ssh-credentials               \
        github                        \
        ghprb                         \
        workflow-scm-step             \
        subversion                    \
        git                           \
        git-client                    \
        git-parameter                 \
        git-changelog                 \
        pipeline-build-step           \
        workflow-aggregator           \
        parameterized-trigger         \
        slave-setup                   \
        cisco-spark                   \
        multi-slave-config-plugin     \
        marathon                      \
        ssh-slaves                    \
        docker-plugin                 \
        docker-workflow               \
        docker-slaves                 \
        docker-build-publish          \
        ldap                          \
        simple-travis-runner


# Add the Cisco self signed cert for LDAP into the trust store

# indicate that this Jenkins installation is fully configured. Otherwise a banner will appear
# prompting the user to install additional plugins, which may be inappropriate.
RUN echo 2.0 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state

RUN echo "America/New_York" > /etc/timezone
ENV TZ America/New_York
#
# Drop back down as user jenkins
# Run as root because we mount host volumes
USER jenkins

HEALTHCHECK CMD curl --fail http://localhost:8080 || exit 1

VOLUME $JENKINS_HOME
EXPOSE 50000
EXPOSE 8080
