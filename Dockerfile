FROM jenkins:alpine

ENV JENKINS_HOME_PLUGINS /var/jenkins_home/plugins
ENV JENKINS_HOME /var/jenkins_home
RUN mkdir -p "$JENKINS_HOME" && chown -R jenkins:jenkins "$JENKINS_HOME"


ADD batch-install-jenkins-plugins.sh /batch-install-jenkins-plugins.sh
ADD incl-plugins.txt /incl-plugins.txt
ADD excl-plugins.txt /excl-plugins.txt

USER root
RUN apk add --no-cache python
RUN mkdir -p "$JENKINS_HOME_PLUGINS" \
    && chmod +x /batch-install-jenkins-plugins.sh \
    && sync \
    && /batch-install-jenkins-plugins.sh -p /incl-plugins.txt -e /excl-plugins.txt -v=1 -d "$JENKINS_HOME_PLUGINS" \
    && chown -R jenkins:jenkins "$JENKINS_HOME_PLUGINS"
RUN apk del python
USER jenkins


VOLUME $JENKINS_HOME
EXPOSE 5000
EXPOSE 8080
ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/jenkins.sh"]
