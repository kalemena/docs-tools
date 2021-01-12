#!/bin/bash

# ====
USERID=`id -u`
USERGROUP=`id -g`

DOCKER_USERID=${DOCKER_USERID:-$USERID:$USERGROUP}
DOCKER_USERID_ARG=${DOCKER_USERID_ARG:--u ${DOCKER_USERID}}

PATH_PROJECT=${PATH_PROJECT:-.}
pushd "${PATH_PROJECT}" &>/dev/null || return $? # On error, return error code
PATH_PROJECT=`pwd -P`
popd &> /dev/null

PATH_DOC_SRC=${PATH_DOC_SRC:-${PATH_PROJECT}/src/adoc}
PATH_DOC_BUILD=${PATH_DOC_BUILD:-${PATH_PROJECT}/build}

echo "===="
echo "Running as User : ${USERID}:${USERGROUP}"
echo "Path Project    : ${PATH_PROJECT}"
echo "Path Doc Src    : ${PATH_DOC_SRC}"
echo "Path Doc Build  : ${PATH_DOC_BUILD}"
# ====

timestamp() {
    echo `date "+%Y-%m-%d %H:%M:%S"`
}

copyFile()
{
    echo "===="
    echo "Copying doc content to 'build' folder ..."
    docker run ${DOCKER_USERID_ARG} --rm -v ${PATH_PROJECT}:${PATH_PROJECT} alpine rm -rf ${PATH_DOC_BUILD} && cp -r ${PATH_DOC_SRC} ${PATH_DOC_BUILD}
    echo "===="
}

buildAssets()
{
    echo "===="
    echo "Building 'assets' ..."
    docker run ${DOCKER_USERID_ARG} --rm \
        -v ${PATH_DOC_BUILD}:/docs \
        -w /docs/assets kalemena/diagrams:latest bash \
        -c 'for FILE in /docs/assets/*.py; do python ${FILE}; done && pwd && ls -la && mv /docs/assets/*.png /docs/images/'
    echo "===="
}

publishConfluence()
{
    echo "===="
    echo "Publishing to Confluence ..."
    docker run ${DOCKER_USERID_ARG} --rm --env-file .env-confluence \
        --network docs-tools_default \
        -e ATTRIBUTES="{ \"confluencePublisherVersion\": \"0.0.0-SNAPSHOT\"}" \
        -v `pwd`/build:/docs \
        confluencepublisher/confluence-publisher:0.0.0-SNAPSHOT
    echo "===="
}

publishPDF()
{
    REVISION=${REVISION:-latest}

    for FILE in ${PATH_PROJECT}/build/_*-Book.adoc; do 
        echo "===="
        FILENAME=$(/usr/bin/basename "${FILE}")
        echo "Publishing to PDF ... ${FILENAME}"

        docker run ${DOCKER_USERID_ARG} --rm --name docsbuild \
            -v ${PATH_PROJECT}:/project \
            asciidoctor/docker-asciidoctor \
            asciidoctor-pdf -a allow-uri-read -a icons=font -r asciidoctor-diagram -D /project/build/ -B /project/build /project/build/${FILENAME}
        # -a pdf-style=/docs/themes/advanced-theme.yml
        echo "===="
    done
}
