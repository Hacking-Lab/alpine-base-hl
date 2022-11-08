FROM alpine:3.16
MAINTAINER Ivan Buetler <ivan.buetler@compass-security.com>

# Add s6-overlay
ENV S6_OVERLAY_VERSION=v3.1.2.1

RUN apk add --update --no-cache bind-tools curl libcap bash net-tools openssl pwgen xz && \ 
	apk upgrade --available && \
	curl -sSL https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz | tar -Jxpf - -C /  && \
	curl -sSL https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-i686.tar.xz | tar -Jxpf - -C /  && \
	rm -rf /var/cache/apk/*

COPY root /

ENTRYPOINT ["/init"]
CMD []
