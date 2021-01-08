#!/bin/bash

echo `date "+%Y-%m-%d %H:%M:%S"`
source ./publishAssets.sh

echo "===="
echo "Publishing to Confluence ..."
docker run ${DOCKER_USERID_ARG} --rm --env-file .env-confluence \
    --network docs-tools_default \
    -e ATTRIBUTES="{ \"confluencePublisherVersion\": \"0.0.0-SNAPSHOT\"}" \
    -v `pwd`/build:/docs \
    confluencepublisher/confluence-publisher:0.0.0-SNAPSHOT

#docker-compose up publisher-confluence
echo "===="

echo `date "+%Y-%m-%d %H:%M:%S"`