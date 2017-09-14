FROM debian:jessie
MAINTAINER Falko Zurell <falko.zurell@ubirch.com>

# These are just a fall back. They are not used called via our normal build.sh
# http://download.oracle.com/otn-pub/java/jdk/8u144-b01/090f390dda5b47b9b721c7dfaa008135/jdk-8u144-linux-i586.tar.gz?AuthParam=1505409181_003c6bc09ab8c5b9aeee0f8142d92be1
ARG JAVA_VERSION=8
ARG JAVA_UPDATE=144
ARG JAVA_BUILD=-b01

# Build-time metadata as defined at http://label-schema.org
  ARG BUILD_DATE
  ARG VCS_REF
  LABEL org.label-schema.build-date=$BUILD_DATE \
        org.label-schema.docker.dockerfile="/Dockerfile" \
        org.label-schema.license="MIT" \
        org.label-schema.name="ubirch basic java container" \
        org.label-schema.url="https://ubirch.com" \
        org.label-schema.vcs-ref=$VCS_REF \
        org.label-schema.vcs-type="Git" \
        org.label-schema.vcs-url="https://github.com/ubirch/docker-java"

ENV JAVA_HOME /usr/lib/jvm/java-${JAVA_VERSION}-oracle
# Java 8 URL: http://download.oracle.com/otn-pub/java/jdk/8u45-b14/jdk-8u45-linux-x64.tar.gz


RUN apt-get update && apt-get install ca-certificates curl -y
WORKDIR /
COPY jdk-8u144-linux-x64.tar.gz /
RUN tar xfz /jdk-8u144-linux-x64.tar.gz -C /tmp && \
    mkdir -p /usr/lib/jvm && mv /tmp/jdk1.8.0_144 "${JAVA_HOME}"

RUN update-alternatives --install "/usr/bin/java" "java" "${JAVA_HOME}/bin/java" 1 && \
    update-alternatives --install "/usr/bin/javaws" "javaws" "${JAVA_HOME}/bin/javaws" 1 && \
    update-alternatives --install "/usr/bin/javac" "javac" "${JAVA_HOME}/bin/javac" 1 && \
    update-alternatives --set java "${JAVA_HOME}/bin/java" && \
    update-alternatives --set javaws "${JAVA_HOME}/bin/javaws" && \
    update-alternatives --set javac "${JAVA_HOME}/bin/javac"

RUN apt-get autoclean && apt-get --purge -y autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN mkdir /build
VOLUME /build
WORKDIR /build
CMD ["/usr/bin/java"]
