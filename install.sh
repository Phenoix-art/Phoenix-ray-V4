#!/bin/sh

echo "Downloading Xray latest release..."
XRAY_VER=$(curl -s https://api.github.com/repos/XTLS/Xray-core/releases/latest | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
if [ -z "$XRAY_VER" ]; then
  XRAY_VER="v26.3.27"
fi

ARCH="linux-64"
URL="https://github.com/XTLS/Xray-core/releases/download/${XRAY_VER}/Xray-${ARCH}.zip"
echo "Version: ${XRAY_VER}"
echo "URL: ${URL}"

wget -O /tmp/xray.zip "$URL" || wget -O /tmp/xray.zip "https://github.com/XTLS/Xray-core/releases/download/${XRAY_VER}/Xray-linux-64.zip"

unzip -o /tmp/xray.zip -d /tmp/xray-bin/
chmod +x /tmp/xray-bin/xray
mv /tmp/xray-bin/xray /usr/local/bin/xray
chmod +x /usr/local/bin/xray

rm -rf /tmp/xray.zip /tmp/xray-bin

echo "Xray installed: $(xray version)"
