FROM debian:jessie

#
# I got the idea for this Docker file from 2 different repos:
# tianon/dockerfiles
# &&& 
# another with the update scripts
#
#
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		ca-certificates curl python wget \
		\
		git openssh-client \
	&& rm -rf /var/lib/apt/lists/*

# grab gosu for easy step-down from root
ENV GOSU_VERSION 1.7
RUN set -x \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
	&& rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true

# grab tini for signal processing and zombie killing
ENV TINI_VERSION v0.9.0
RUN set -x \
	&& wget -O /usr/local/bin/tini "https://github.com/krallin/tini/releases/download/$TINI_VERSION/tini" \
	&& wget -O /usr/local/bin/tini.asc "https://github.com/krallin/tini/releases/download/$TINI_VERSION/tini.asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 6380DC428747F6C393FEACA59A84159D7001A4E5 \
	&& gpg --batch --verify /usr/local/bin/tini.asc /usr/local/bin/tini \
	&& rm -r "$GNUPGHOME" /usr/local/bin/tini.asc \
	&& chmod +x /usr/local/bin/tini \
	&& tini -h

RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 150FDE3F7787E7D11EF4E12A9B7D32F2D50582E6
RUN echo 'deb http://pkg.jenkins-ci.org/debian binary/' > /etc/apt/sources.list.d/jenkins.list

ENV JENKINS_VERSION 2.16

RUN apt-get update && apt-get install -y --no-install-recommends \
		jenkins=${JENKINS_VERSION} \
	&& rm -rf /var/lib/apt/lists/*

ENV JENKINS_HOME_PLUGINS /var/jenkins_home/plugins
ENV JENKINS_HOME /var/jenkins_home
RUN mkdir -p "$JENKINS_HOME" && chown -R jenkins:jenkins "$JENKINS_HOME"

ADD batch-install-jenkins-plugins.sh /batch-install-jenkins-plugins.sh
ADD incl-plugins.txt /incl-plugins.txt
ADD excl-plugins.txt /excl-plugins.txt
RUN mkdir -p "$JENKINS_HOME_PLUGINS" \
    && chmod +x /batch-install-jenkins-plugins.sh \
    && sync \
    && /batch-install-jenkins-plugins.sh -p /incl-plugins.txt -e /excl-plugins.txt -v=1 -d "$JENKINS_HOME_PLUGINS" \
    && chown -R jenkins:jenkins "$JENKINS_HOME_PLUGINS"

VOLUME $JENKINS_HOME

EXPOSE 8080

CMD ["java", "-jar", "/usr/share/jenkins/jenkins.war"]
