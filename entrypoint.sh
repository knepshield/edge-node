#!/bin/sh
set -e
PORT="${PORT:-8080}"
UUID="${UUID:?UUID env required}"
WS_PATH="${WS_PATH:-/ws}"
cat > /tmp/config.json <<JSON
{
  "log": {"loglevel": "warning"},
  "inbounds": [{
    "port": ${PORT},
    "protocol": "vless",
    "settings": {"clients": [{"id": "${UUID}"}], "decryption": "none"},
    "streamSettings": {"network": "ws", "wsSettings": {"path": "${WS_PATH}"}}
  }],
  "outbounds": [{"protocol": "freedom"}]
}
JSON
exec /usr/local/bin/xray run -c /tmp/config.json
