FROM jenkins:alpine


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

RUN apk add --no-cache subversion

ENV JENKINS_HOME "/var/jenkins_home"
ENV JENKINS_HOME_PLUGINS "/usr/share/jenkins/ref/plugins"

# couple of small tweaks to the install script to make it
# download and retry downloads
ADD install-plugins.sh /usr/local/bin/install-plugins.sh

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
        dashboard-view                \
        ansicolor                     \
        greenballs                    \
        htmlpublisher                 \
        credentials                   \
        ssh-credentials               \
        ssh-slaves                    \
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
        simple-travis-runner

USER jenkins


VOLUME $JENKINS_HOME
EXPOSE 5000
EXPOSE 8080
ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/jenkins.sh"]
