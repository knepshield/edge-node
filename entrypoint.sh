#!/bin/sh
set -e
PORT="${PORT:-8080}"
WS_PATH="${WS_PATH:-/ws}"
export HOME="${HOME:-/tmp}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-/tmp/caddy-data}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-/tmp/caddy-config}"
mkdir -p "$XDG_DATA_HOME" "$XDG_CONFIG_HOME"
if [ -z "$UUID" ]; then
  for f in /run/secrets/UUID /var/run/secrets/UUID /secrets/UUID "$HOME/.secrets/UUID"; do
    if [ -f "$f" ]; then UUID="$(cat "$f")"; break; fi
  done
fi
UUID="${UUID:?UUID env required}"
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
{
	admin off
	auto_https off
}
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
