#!/bin/bash

case `uname -m` in 

	x86_64)
		echo "=============================================="
		echo "building x86_64"
		docker buildx build --platform linux/amd64 --no-cache -t hackinglab/alpine-base-hl:amd64-$1.0 -t hackinglab/alpine-base-hl:amd64-$1 -t hackinglab/alpine-base-hl:amd64-latest -f Dockerfile.amd64 .

		echo "=============================================="
		echo "docker push hackinglab/alpine-base-hl:amd64"
		docker push hackinglab/alpine-base-hl:amd64
		echo "=============================================="
		echo "docker push hackinglab/alpine-base-hl:amd64-$1"
		docker push hackinglab/alpine-base-hl:amd64-$1
		echo "=============================================="
		echo "docker push hackinglab/alpine-base-hl:amd64-$1.0"
		docker push hackinglab/alpine-base-hl:amd64-$1.0
	;;

	aarch64)
                echo "=============================================="
                echo "building aarch64"
                docker buildx build --platform linux/arm64 --no-cache -t hackinglab/alpine-base-hl:arm64-$1.0 -t hackinglab/alpine-base-hl:arm64-$1 -t hackinglab/alpine-base-hl:arm64-latest -f Dockerfile.arm64 .

                echo "=============================================="
                echo "docker push hackinglab/alpine-base-hl:arm64"
                docker push hackinglab/alpine-base-hl:arm64
                echo "=============================================="
                echo "docker push hackinglab/alpine-base-hl:arm64-$1"
                docker push hackinglab/alpine-base-hl:arm64-$1
                echo "=============================================="
                echo "docker push hackinglab/alpine-base-hl:arm64-$1.0"
                docker push hackinglab/alpine-base-hl:arm64-$1.0

	;;

	*)
		echo "OS not found"
	;;
esac
