FROM alpine:latest
LABEL maintainer="Ivan Buetler <ivan.buetler@hacking-lab.com>"

# Add s6-overlay
#ENV S6_OVERLAY_VERSION=3.1.6.2
ENV S6_OVERLAY_VERSION=3.2.0.2

# Use BuildKit to help translate architecture names
ARG TARGETPLATFORM

RUN case "${TARGETPLATFORM}" in \
         "linux/amd64")  S6_ARCH=s6-overlay-x86_64.tar.xz ;; \
         "linux/arm64")  S6_ARCH=s6-overlay-aarch64.tar.xz ;; \
         *) exit 1 ;; \
    esac; \
    echo "${TARGETPLATFORM} -> ${S6_ARCH}" > /etc/hl-arch.txt && \ 
    apk add --update --no-cache bind-tools curl libcap bash net-tools openssl pwgen xz sudo && \ 
    apk upgrade --available && \
    curl -sSL https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz | tar -Jxpf - -C /  && \
    curl -sSL https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/${S6_ARCH} | tar -Jxpf - -C /  && \
    rm -rf /var/cache/apk/*

ADD root /

ENTRYPOINT ["/init"]
