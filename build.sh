#!/bin/bash

mkdir -p VAR && docker build --build-arg JAVA_VERSION=${JAVA_VERSION:=8} \
  --build-arg JAVA_UPDATE=${JAVA_UPDATE:=77} \
  --build-arg JAVA_BUILD=${JAVA_BUILD:=03} \
  -t ubirch/java .
  if [ $? -eq 0 ]; then
    echo ${JAVA_VERSION:=8} > VAR/JAVA_VERSION
    echo ${JAVA_UPDATE:=77} > VAR/JAVA_UPDATE
    echo ${JAVA_BUILD:=03} > VAR/JAVA_BUILD
  fi
