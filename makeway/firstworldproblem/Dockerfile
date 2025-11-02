FROM tesuji777/pwnkernel:latest AS base

ENV DEBIAN_FRONTEND=noninteractive

ARG KVER
ENV KVER=${KVER:-6.8.0-83-generic}

SHELL ["/bin/bash", "-c"]

WORKDIR /src
COPY . /src/
RUN <<EOF
set -e
make
cp echo.ko /challenge/
EOF
