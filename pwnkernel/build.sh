#!/bin/bash

extra_args=()
if [ "push" == "$1" ]; then
  extra_args+=( "--push" )
fi
docker buildx build --platform linux/amd64 -t tesuji777/pwnkernel "${extra_args[@]}" .
