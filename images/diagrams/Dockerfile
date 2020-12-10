FROM python:3.7

RUN apt-get update -y \
    && apt-get install graphviz -y \
    && rm -r /var/lib/apt/lists/*

RUN pip --no-cache-dir install diagrams

RUN mkdir -p /diagrams

WORKDIR /diagrams

CMD ["python"]