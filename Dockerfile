ARG JENKINS_VERSION
FROM jenkins/jenkins:$JENKINS_VERSION
# I'm specifically NOT using the alpine image version


#
# Install docker
#
USER root

RUN apt-get update && apt-get install -y \
             subversion   \
             curl         \
             vim          \
             procps       \
             lsb-core       \
             apt-transport-https \
             ca-certificates   \
             software-properties-common \
             git

#
# Install newest version of docker
#
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN  add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

RUN apt-get update && apt-get install docker-ce -y


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
#USER jenkins

HEALTHCHECK CMD curl --fail http://localhost:8080 || exit 1

VOLUME $JENKINS_HOME
EXPOSE 50000
EXPOSE 8080
