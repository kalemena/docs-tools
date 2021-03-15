FROM python:3.9-alpine

# FROM https://github.com/mingrammer/diagrams (under /docker/dev hence preventing direct build)

ARG VERSION=0.19.1

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="Kalemena NodeRed" \
      org.label-schema.description="Kalemena NodeRed for use in home automation" \
      org.label-schema.url="private" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/kalemena/docker-node-red" \
      org.label-schema.vendor="Kalemena" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"

RUN apk update && apk add --no-cache \
  gcc libc-dev g++ graphviz git bash go imagemagick inkscape ttf-opensans curl fontconfig

# install go package.
RUN go get github.com/mingrammer/round

# install fonts
RUN curl -O https://noto-website.storage.googleapis.com/pkgs/NotoSansCJKjp-hinted.zip \
&& mkdir -p /usr/share/fonts/NotoSansCJKjp \
&& unzip NotoSansCJKjp-hinted.zip -d /usr/share/fonts/NotoSansCJKjp/ \
&& rm NotoSansCJKjp-hinted.zip \
&& fc-cache -fv

# add go bin to path.
ENV PATH "$PATH:/root/go/bin"

# Copy the rest of your app's source code from your host to your image filesystem.
RUN cd /tmp \
  && wget https://github.com/mingrammer/diagrams/archive/v${VERSION}.zip \
  && unzip v${VERSION}.zip -d /usr/src/ \
  && rm /tmp/v${VERSION}.zip \
  && mv /usr/src/diagrams-${VERSION} /usr/src/diagrams

COPY [ "*.py", "/usr/src/diagrams/" ]

# install python requirements.
RUN pip install black graphviz jinja2

ENV PYTHONPATH "$PYTHONPATH:/usr/src/diagrams"

WORKDIR /diagrams

CMD ["python"]