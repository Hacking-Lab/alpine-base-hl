FROM alpine:latest
LABEL maintainer="Ivan Buetler <ivan.buetler@hacking-lab.com>"

# Adding s6-overlay
ENV S6_OVERLAY_VERSION=3.2.3.0

# Use BuildKit to help translate architecture names
ARG TARGETPLATFORM

RUN set -eux; \
    case "${TARGETPLATFORM:-$(apk --print-arch)}" in \
         "linux/amd64")  S6_ARCH=s6-overlay-x86_64.tar.xz ;; \
         "linux/arm64")  S6_ARCH=s6-overlay-aarch64.tar.xz ;; \
         "x86_64")       S6_ARCH=s6-overlay-x86_64.tar.xz ;; \
         "aarch64")      S6_ARCH=s6-overlay-aarch64.tar.xz ;; \
         *) exit 1 ;; \
    esac; \
    echo "${TARGETPLATFORM:-$(apk --print-arch)} -> ${S6_ARCH}" > /etc/hl-arch.txt && \
    apk add --update --no-cache bind-tools curl libcap bash net-tools openssl pwgen xz sudo busybox-suid vim file procps ca-certificates && \
    apk upgrade --available && \
    curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz" | tar -Jxpf - -C /  && \
    curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/${S6_ARCH}" | tar -Jxpf - -C /  && \
    rm -rf /var/cache/apk/*

ADD root /

# Adding s6 path to PATH
ENV PATH="/command:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

ENTRYPOINT ["/init"]
