#!/bin/sh
set -e
PORT="${PORT:-8080}"
UUID="${UUID:?UUID env required}"
WS_PATH="${WS_PATH:-/ws}"
cat > /tmp/config.json <<JSON
{
  "log": {"loglevel": "warning"},
  "inbounds": [{
    "listen": "127.0.0.1",
    "port": 18080,
    "protocol": "vless",
    "settings": {"clients": [{"id": "${UUID}"}], "decryption": "none"},
    "streamSettings": {"network": "ws", "wsSettings": {"path": "${WS_PATH}"}}
  }],
  "outbounds": [{"protocol": "freedom"}]
}
JSON
cat > /tmp/Caddyfile <<CADDY
:${PORT} {
	handle ${WS_PATH} {
		reverse_proxy 127.0.0.1:18080
	}
	handle {
		respond "ok" 200
	}
}
CADDY
/usr/local/bin/xray run -c /tmp/config.json &
exec caddy run --config /tmp/Caddyfile --adapter caddyfile
