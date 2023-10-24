#!/bin/bash

docker buildx build --platform linux/arm64,linux/amd64 -t hackinglab/alpine-base-hl:latest . 
docker buildx build --platform linux/arm64,linux/amd64 -t hackinglab/alpine-base-hl:$1  . 
docker buildx build --platform linux/arm64,linux/amd64 -t hackinglab/alpine-base-hl:$1.0 .
