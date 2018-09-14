FROM debian:stretch
MAINTAINER Falko Zurell <falko.zurell@ubirch.com>

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


RUN apt-get update && apt-get install ca-certificates curl openjdk-8-jdk -y
WORKDIR /

RUN apt-get autoclean && apt-get --purge -y autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN mkdir /build
VOLUME /build
WORKDIR /build
CMD ["/usr/bin/java"]
