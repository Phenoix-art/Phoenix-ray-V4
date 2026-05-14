#!/bin/bash

echo "======================================"
echo "G2Ray - Configurable VLESS Proxy"
echo "======================================"
echo ""
echo "Starting Xray..."
echo ""

exec /usr/local/bin/xray -c /etc/g2ray-generated.json
