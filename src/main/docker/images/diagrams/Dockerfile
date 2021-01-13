FROM python:3.9-alpine

# FROM https://github.com/mingrammer/diagrams (under /docker/dev hence preventing direct build)

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
  && wget https://github.com/mingrammer/diagrams/archive/v0.18.0.zip \
  && unzip v0.18.0.zip -d /usr/src/ \
  && rm /tmp/v0.18.0.zip \
  && mv /usr/src/diagrams-0.18.0 /usr/src/diagrams

COPY [ "*.py", "/usr/src/diagrams/" ]

# install python requirements.
RUN pip install black graphviz jinja2

ENV PYTHONPATH "$PYTHONPATH:/usr/src/diagrams"

WORKDIR /diagrams

CMD ["python"]