FROM alpine:3.24
ARG XRAY_VERSION=26.11.9
ARG TARGETARCH
RUN apk upgrade --no-cache && apk add --no-cache curl unzip ca-certificates caddy && \
    case "$TARGETARCH" in \
      arm64) XRAY_ZIP="Xray-linux-arm64-v8a.zip" ;; \
      *) XRAY_ZIP="Xray-linux-64.zip" ;; \
    esac && \
    curl -fsSL -o /tmp/xray.zip "https://github.com/XTLS/Xray-core/releases/download/v${XRAY_VERSION}/${XRAY_ZIP}" && \
    unzip -o /tmp/xray.zip -d /usr/local/bin xray geoip.dat geosite.dat && \
    chmod +x /usr/local/bin/xray && rm -f /tmp/xray.zip && \
    apk del curl unzip
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
EXPOSE 8080
ENTRYPOINT ["/entrypoint.sh"]
