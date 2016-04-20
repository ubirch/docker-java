FROM debian:jessie
MAINTAINER Falko Zurell <falko.zurell@ubirch.com>

ARG JAVA_VERSION=8
ARG JAVA_UPDATE=45
ARG JAVA_BUILD=14

ENV JAVA_HOME /usr/lib/jvm/java-${JAVA_VERSION}-oracle
# Java 8 URL: http://download.oracle.com/otn-pub/java/jdk/8u45-b14/jdk-8u45-linux-x64.tar.gz


RUN apt-get update && apt-get install ca-certificates curl -y && \
    curl --silent --location --retry 3 --cacert /etc/ssl/certs/GeoTrust_Global_CA.pem \
    --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
    http://download.oracle.com/otn-pub/java/jdk/"${JAVA_VERSION}"u"${JAVA_UPDATE}"-b"${JAVA_BUILD}"/jdk-"${JAVA_VERSION}"u"${JAVA_UPDATE}"-linux-x64.tar.gz \
    | tar xz -C /tmp && \
    mkdir -p /usr/lib/jvm && mv /tmp/jdk1.${JAVA_VERSION}.0_${JAVA_UPDATE} "${JAVA_HOME}" && \
    apt-get autoclean && apt-get --purge -y autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN update-alternatives --install "/usr/bin/java" "java" "${JAVA_HOME}/bin/java" 1 && \
    update-alternatives --install "/usr/bin/javaws" "javaws" "${JAVA_HOME}/bin/javaws" 1 && \
    update-alternatives --install "/usr/bin/javac" "javac" "${JAVA_HOME}/bin/javac" 1 && \
    update-alternatives --set java "${JAVA_HOME}/bin/java" && \
    update-alternatives --set javaws "${JAVA_HOME}/bin/javaws" && \
    update-alternatives --set javac "${JAVA_HOME}/bin/javac"
