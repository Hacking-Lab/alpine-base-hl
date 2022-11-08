#!/bin/bash

case `uname -m` in 

	x86_64)
		echo "x86_64"
		docker build --no-cache -t hackinglab/alpine-base-hl:amd64-3.2.0 -t hackinglab/alpine-base-hl:amd64-3.2 -t hackinglab/alpine-base-hl:amd64-latest -f Dockerfile.amd64 .
	;;

	arm64)
		echo "arm64"
	;;

	*)
		echo "OS not found"
	;;
esac
