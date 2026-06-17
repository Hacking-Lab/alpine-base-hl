# Hacking-Lab Alpine Base image for amd64/arm64
## Introduction
This is the Hacking-Lab multi-architecture CTF Alpine base image (amd64/arm64) 

## Specifications
* with s6 startup handling (version v3.2.3.0)
* with dynamic user creation
* with or without known passwords for root and non-root user
* with `env` based dynamic ctf flag handling
* with `file` based dynamic ctf flag handling

## Docker Hub
https://hub.docker.com/repository/docker/hackinglab/alpine-base-hl

```bash
services:
  alpine-base-hl:
    build: .
    image: hackinglab/alpine-base-hl:3.2
    environment:
      - HL_USER_USERNAME=hacker
      - HL_USER_PASSWORD=compass
      - HL_ROOT_PASSWORD=<change-me>
      - GOLDNUGGET=FLAG{myflag}
```


## CONFIGURATION
You can specify the user that will be created in the container. 
Please use the env variables listed below.

* HL_USER_USERNAME=hacker
* HL_USER_PASSWORD=compass
* HL_ROOT_PASSWORD=change-me

## Maintenance

To update s6-overlay, run the updater script with the new upstream version. It downloads the release assets, recalculates SHA-256 checksums, and patches the Dockerfile.

```bash
./update-s6-overlay.sh 3.2.3.0
./update-s6-overlay.sh --legacy 3.2.1.0
```

After updating, rebuild the image so Docker verifies the pinned checksums during the build.
