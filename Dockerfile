FROM alpine:3.24
ARG XRAY_VERSION=26.11.9
RUN apk upgrade --no-cache && apk add --no-cache curl unzip ca-certificates caddy && \
    curl -fsSL -o /tmp/xray.zip "https://github.com/XTLS/Xray-core/releases/download/v${XRAY_VERSION}/Xray-linux-64.zip" && \
    unzip -o /tmp/xray.zip -d /usr/local/bin xray geoip.dat geosite.dat && \
    chmod +x /usr/local/bin/xray && rm -f /tmp/xray.zip && \
    apk del curl unzip
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
EXPOSE 8080
ENTRYPOINT ["/entrypoint.sh"]
