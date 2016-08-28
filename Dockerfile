FROM jenkins:alpine

ENV JENKINS_HOME /var/jenkins_home
#RUN mkdir -p "$JENKINS_HOME" && chown -R jenkins:jenkins "$JENKINS_HOME"

#
# The new jenkins Dockerfile now has a script that will automatically download
# a plugin and all dependencies, we just have to put call it in the Dockerfile
#
# we will then call install-plugins.sh
#
USER root
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
        mesos                         \
        marathon                      \
        ssh-slaves                    \
        docker-plugin                 \
        docker-workflow               \
        docker-slaves                 \
        docker-build-publish


USER jenkins


VOLUME $JENKINS_HOME
EXPOSE 5000
EXPOSE 8080
ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/jenkins.sh"]
