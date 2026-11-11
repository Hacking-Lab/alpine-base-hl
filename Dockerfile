FROM alpine:latest
LABEL maintainer="Ivan Buetler <ivan.buetler@hacking-lab.com>"

# Adding s6-overlay
ENV S6_OVERLAY_VERSION=3.2.3.2
ENV S6_OVERLAY_NOARCH_SHA256=5379750ed30a84bbd2e2dd74847ba6b5bd29cd0b2e3ea2ec58049b57eb2eda12
ENV S6_OVERLAY_X86_64_SHA256=e6befcc96a437a3831386ecfc51808c5d3e939dc5fe3c02ae9284599e8aa2408
ENV S6_OVERLAY_AARCH64_SHA256=b17f17a82e7a515c682a91edaf2ffdabb73f891981b6c1fd712115693a2f8b4c

# Use BuildKit to help translate architecture names
ARG TARGETPLATFORM

RUN set -eux; \
    case "${TARGETPLATFORM:-$(apk --print-arch)}" in \
         "linux/amd64"|"x86_64")   S6_ARCH=s6-overlay-x86_64.tar.xz; S6_ARCH_SHA256="${S6_OVERLAY_X86_64_SHA256}" ;; \
         "linux/arm64"|"aarch64")  S6_ARCH=s6-overlay-aarch64.tar.xz; S6_ARCH_SHA256="${S6_OVERLAY_AARCH64_SHA256}" ;; \
         *) exit 1 ;; \
    esac; \
    echo "${TARGETPLATFORM:-$(apk --print-arch)} -> ${S6_ARCH}" > /etc/hl-arch.txt && \
    apk add --update --no-cache bind-tools curl libcap bash net-tools openssl pwgen xz sudo busybox-suid vim file procps ca-certificates && \
    apk upgrade --available && \
    curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz" -o /tmp/s6-overlay-noarch.tar.xz && \
    curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/${S6_ARCH}" -o "/tmp/${S6_ARCH}" && \
    printf '%s  %s\n' "${S6_OVERLAY_NOARCH_SHA256}" /tmp/s6-overlay-noarch.tar.xz "${S6_ARCH_SHA256}" "/tmp/${S6_ARCH}" | sha256sum -c - && \
    tar -Jxpf /tmp/s6-overlay-noarch.tar.xz -C / && \
    tar -Jxpf "/tmp/${S6_ARCH}" -C / && \
    rm -f /tmp/s6-overlay-noarch.tar.xz "/tmp/${S6_ARCH}" && \
    rm -rf /var/cache/apk/*

COPY root /

# Adding s6 path to PATH
ENV PATH="/command:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

ENTRYPOINT ["/init"]
