# Alpine Base amd64/arm64
## Introduction
This is the Hacking-Lab multi-architecture CTF Alpine base image (amd64/arm64) 

## Specifications
* with s6 startup handling (version v3.2.2.0)
* with dynamic user creation
* with or without known passwords for root and non-root user
* with `env` based dynamic ctf flag handling
* with `file` based dynamic ctf flag handling

## Build & Test
````bash
docker compose up --build
```

## CONFIGURATION
You can specify the user that will be created in the container. 
Please use the env variables listed below.

* HL_USER_USERNAME=hacker
* HL_USER_PASSWORD=compass
* HL_ROOT_PASSWORD=very_secure

## EXAMPLE docker-compose.yml
```bash
services:
  alpine-base-HL:
    build: .
    image: hackinglab/alpine-base-HL:3.2
    environment:
      - HL_USER_USERNAME=hacker
      - HL_USER_PASSWORD=compass
      - HL_ROOT_PASSWORD=<change-me>
```
