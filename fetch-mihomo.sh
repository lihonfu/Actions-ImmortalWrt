#!/bin/bash
# Download the latest Mihomo core and place it where OpenClash expects it.
# Best effort: a failure here must not break the firmware build.
set -u
OUT_DIR="files/etc/openclash/core"
OUT="$OUT_DIR/clash_meta"
mkdir -p "$OUT_DIR" || exit 0
URL=$(curl -fsSL --max-time 120 https://api.github.com/repos/MetaCubeX/mihomo/releases/latest \
	| grep -o '"browser_download_url": *"[^"]*mihomo-linux-arm64[^"]*\.gz"' \
	| head -n1 | cut -d'"' -f4)
if [ -z "${URL:-}" ]; then
	echo "Mihomo: latest release not resolved"
	exit 0
fi
if curl -fsSL --max-time 300 "$URL" | gzip -dc > "$OUT" 2>/dev/null; then
	chmod +x "$OUT"
	echo "Mihomo core baked in: $URL"
else
	rm -f "$OUT"
	echo "Mihomo core download failed: $URL"
fi
exit 0