#!/bin/bash

docker buildx build --platform linux/amd64 -t tesuji777/pwnkernel --push .
