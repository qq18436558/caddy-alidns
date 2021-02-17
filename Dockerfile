FROM alpine:3.13.1

RUN apk add --no-cache ca-certificates mailcap

RUN set -eux; mkdir -p /config/caddy /data/caddy /etc/caddy /usr/share/caddy; \
	wget -O /etc/caddy/Caddyfile "https://github.com/caddyserver/dist/raw/56302336e0bb7c8c5dff34cbcb1d833791478226/config/Caddyfile"; \
	wget -O /usr/share/caddy/index.html "https://github.com/caddyserver/dist/raw/56302336e0bb7c8c5dff34cbcb1d833791478226/welcome/index.html"

ENV CADDY_VERSION v2.3.0

RUN set -eux; \
	wget -O /tmp/caddy.tar.gz "https://github.com/qq18436558/caddy-alidns/releases/download/v1/caddy_230.tar.gz"; \
	tar x -z -f /tmp/caddy.tar.gz -C /usr/bin caddy; \
	rm -f /tmp/caddy.tar.gz; \
	chmod +x /usr/bin/caddy; \
	caddy version

RUN [ ! -e /etc/nsswitch.conf ] && echo 'hosts: files dns' > /etc/nsswitch.conf

ENV XDG_CONFIG_HOME /config
ENV XDG_DATA_HOME /data

VOLUME /config
VOLUME /data

LABEL org.opencontainers.image.version=v2.3.0
LABEL org.opencontainers.image.title=Caddy
LABEL org.opencontainers.image.description="a powerful, enterprise-ready, open source web server with automatic HTTPS written in Go"
LABEL org.opencontainers.image.url=https://caddyserver.com
LABEL org.opencontainers.image.documentation=https://caddyserver.com/docs
LABEL org.opencontainers.image.vendor="Light Code Labs"
LABEL org.opencontainers.image.licenses=Apache-2.0
LABEL org.opencontainers.image.source="https://github.com/caddyserver/caddy-docker"

EXPOSE 80
EXPOSE 443
EXPOSE 2019

WORKDIR /srv

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]