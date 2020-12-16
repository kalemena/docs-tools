#!/bin/bash

rm -rf `pwd`/build
cp -r `pwd`/docs-sample `pwd`/build

docker run --rm -it \
    -v `pwd`/build:/docs \
    kalemena/asciidoc:0.4.0 \
    asciidoctor-pdf -a allow-uri-read -a icons=font -r asciidoctor-diagram -D /docs/ -B /docs /docs/_pdfbook.adoc
