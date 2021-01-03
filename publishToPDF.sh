#!/bin/bash

echo `date "+%Y-%m-%d %H:%M:%S"`
source ./publishAssets.sh

REVISION=${REVISION:-latest}

for FILE in ${PATH_PROJECT}/build/_*-Book.adoc; do 
    echo "===="
    FILENAME=$(/usr/bin/basename "${FILE}")
    echo "Publishing to PDF ... ${FILENAME}"

    docker run ${DOCKER_USERID} --rm --name docsbuild \
        -v ${PATH_PROJECT}:/project \
        asciidoctor/docker-asciidoctor \
        asciidoctor-pdf -a allow-uri-read -a icons=font -r asciidoctor-diagram -D /project/build/ -B /project/build /project/build/${FILENAME}
    # -a pdf-style=/docs/themes/advanced-theme.yml
    echo "===="
done

echo `date "+%Y-%m-%d %H:%M:%S"`