docker manifest create hackinglab/alpine-base-hl --amend hackinglab/alpine-base-hl:amd64-latest --amend hackinglab/alpine-base-hl:arm64-latest
docker manifest create hackinglab/alpine-base-hl:3.2 --amend hackinglab/alpine-base-hl:amd64-3.2 --amend hackinglab/alpine-base-hl:arm64-3.2
docker manifest create hackinglab/alpine-base-hl:3.2.0 --amend hackinglab/alpine-base-hl:amd64-3.2.0 --amend hackinglab/alpine-base-hl:arm64-3.2.0
docker manifest push hackinglab/alpine-base-hl
docker manifest push hackinglab/alpine-base-hl:3.2
docker manifest push hackinglab/alpine-base-hl:3.2.0
