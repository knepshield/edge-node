FROM alpine:3.20
ARG XRAY_VERSION=25.8.3
RUN apk add --no-cache curl unzip ca-certificates && \
    curl -fsSL -o /tmp/xray.zip "https://github.com/XTLS/Xray-core/releases/download/v${XRAY_VERSION}/Xray-linux-64.zip" && \
    unzip -o /tmp/xray.zip -d /usr/local/bin xray geoip.dat geosite.dat && \
    chmod +x /usr/local/bin/xray && rm -f /tmp/xray.zip
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
EXPOSE 8080
ENTRYPOINT ["/entrypoint.sh"]
