#!/usr/bin/env bash
IMAGE_NAME="downloadticketservice/dl"

if [ ! -f Dockerfile ]
then
	echo "[$0] [ERROR] Dockerfile must be in current directory"
fi

TAG_VERSION=$(awk '{if($1=="LABEL" && $2=="version"){print $3;exit}}' Dockerfile 2>/dev/null)
if [ -z ${TAG_VERSION} ]
then
	echo "[$0] [ERROR] Couldn't find image version to build from Dockerfile 'LABEL version'"
fi
echo "Image name: ${IMAGE_NAME}"
echo "Tag version: ${TAG_VERSION}"

docker build -t ${IMAGE_NAME}:${TAG_VERSION} .
