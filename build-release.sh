#!/bin/bash

case `uname -m` in 

	x86_64)
		echo "=============================================="
		echo "building x86_64"
		docker buildx build --push --platform linux/amd64 --no-cache -t hackinglab/alpine-base-hl:amd64-latest -t hackinglab/alpine-base-hl:amd64-$1 -t hackinglab/alpine-base-hl:amd64-$1.0 -f Dockerfile.amd64 .
	;;

	aarch64)
                echo "=============================================="
                echo "building arm64"
                docker buildx build --push --platform linux/arm64 --no-cache -t hackinglab/alpine-base-hl:arm64-latest -t hackinglab/alpine-base-hl:arm64-$1 -t hackinglab/alpine-base-hl:arm64-$1.0 -f Dockerfile.arm64 .
	;;

	*)
		echo "OS not found"
	;;
esac
