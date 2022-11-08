#!/bin/bash

case `uname -m` in 

	x86_64)
		echo "x86_64"
		docker buildx build --platform linux/amd64 --no-cache -t hackinglab/alpine-base-hl:amd64-3.2.0 -t hackinglab/alpine-base-hl:amd64-3.2 -t hackinglab/alpine-base-hl:amd64-latest -f Dockerfile.amd64 .
	;;

	aarch64)
		echo "aarch64"
		docker buildx build --platform linux/arm64 --no-cache -t hackinglab/alpine-base-hl:arm64-3.2.0 -t hackinglab/alpine-base-hl:arm64-3.2 -t hackinglab/alpine-base-hl:arm64-latest -f Dockerfile.arm64 .
	;;

	*)
		echo "OS not found"
	;;
esac
