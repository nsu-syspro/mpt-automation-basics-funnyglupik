FROM ubuntu:22.04

RUN apt-get update && apt-get install -y gcc make jq

COPY . /cool_dir
WORKDIR /cool_dir

RUN make
RUN make check

ENTRYPOINT ["./build/wordcount"]
