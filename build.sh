#!/bin/bash -x


# build the docker container
function build_container() {
  echo "Building container with JAVA_VERSION=${JAVA_VERSION} JAVA_UPDATE=${JAVA_UPDATE} JAVA_BUILD=${JAVA_BUILD}"


  # Fetch JDK:
  if [ ! -f jdk-8u144-linux-x64.tar.gz ]; then
    curl -L -b "oraclelicense=a" http://download.oracle.com/otn-pub/java/jdk/8u144-b01/090f390dda5b47b9b721c7dfaa008135/jdk-8u144-linux-x64.tar.gz -O jdk-8u144-linux-x64.tar.gz
  fi
  mkdir -p VAR && docker build --build-arg JAVA_VERSION=${JAVA_VERSION:=8} \
    --build-arg JAVA_UPDATE=${JAVA_UPDATE:=144} \
    --build-arg JAVA_BUILD=${JAVA_BUILD:=-b01} \
    --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
    --build-arg VCS_REF=`git rev-parse --short HEAD` \
    -t ubirch/java:v${GO_PIPELINE_LABEL} .
    if [ $? -eq 0 ]; then
      echo ${JAVA_VERSION:=8} > VAR/JAVA_VERSION
      echo ${JAVA_UPDATE:=144} > VAR/JAVA_UPDATE
      echo ${JAVA_BUILD:=-b01} > VAR/JAVA_BUILD
      echo ${NEW_LABEL} > VAR/${GO_PIPELINE_NAME}_${GO_STAGE_NAME}
    else
      echo "Docker build faild"
      exit 1
    fi
}

# publish the new docker container
function publish_container() {
  echo "Publishing Docker Container with version: ${GO_PIPELINE_LABEL}"
  docker push ubirch/java:v${GO_PIPELINE_LABEL} && docker push ubirch/java
  if [ $? -eq 0 ]; then
    echo ${NEW_LABEL} > VAR/${GO_PIPELINE_NAME}_${GO_STAGE_NAME}
  else
    echo "Docker push faild"
    exit 1
  fi

}


case "$1" in
    build)
        build_container
        ;;
    publish)
        publish_container
        ;;
    *)
        echo "Usage: $0 {build|publish}"
        exit 1
esac

exit 0
