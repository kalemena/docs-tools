#!/bin/bash

USERID=`id -u`
USERGROUP=`id -g`

DOCKER_USERID=${DOCKER_USERID:--u $USERID:$USERGROUP}

PATH_PROJECT=${PATH_PROJECT:-.}
pushd "${PATH_PROJECT}" &>/dev/null || return $? # On error, return error code
PATH_PROJECT=`pwd -P`
popd &> /dev/null

PATH_DOC_SRC=${PATH_DOC_SRC:-${PATH_PROJECT}/src/adoc}
PATH_DOC_BUILD=${PATH_DOC_BUILD:-${PATH_PROJECT}/build}

echo "===="
echo "PATH_PROJECT=${PATH_PROJECT}"
echo "PATH_DOC_BUILD=${PATH_DOC_BUILD}"

echo "===="
echo "Copying doc content to 'build' folder ..."
docker run ${DOCKER_USERID} --rm -v ${PATH_PROJECT}:${PATH_PROJECT} alpine rm -rf ${PATH_DOC_BUILD} && cp -r ${PATH_DOC_SRC} ${PATH_DOC_BUILD}

echo "===="