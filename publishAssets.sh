#!/bin/bash

echo `date "+%Y-%m-%d %H:%M:%S"`
source ./publishCommons.sh

echo "===="
echo "Building 'assets' ..."
docker run ${DOCKER_USERID_ARG} --rm -v ${PATH_DOC_BUILD}:/docs -w /docs/assets kalemena/diagrams:latest bash -c 'for FILE in /docs/assets/*.py; do python ${FILE}; done && pwd && ls -la && mv /docs/assets/*.png /docs/images/'
echo "===="

echo `date "+%Y-%m-%d %H:%M:%S"`