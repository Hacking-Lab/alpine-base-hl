#!/bin/bash

case `uname -m` in 

	x86_64)
		echo "=============================================="
		echo "building x86_64"
		docker build --no-cache -t hackinglab/alpine-base-hl:amd64-$1.0 -t hackinglab/alpine-base-hl:amd64-$1 -t hackinglab/alpine-base-hl:amd64-latest -f Dockerfile.amd64 .

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

	arm64)
		echo "building arm64"
	;;

	*)
		echo "OS not found"
	;;
esac
