FROM debian:bookworm-slim

COPY install.sh /app/install.sh

WORKDIR /app

RUN echo "Installing system dependencies..." && \
    apt-get update && apt-get install -y --no-install-recommends \
    bash git curl wget unzip tzdata openssl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN chmod +x /app/install.sh && /app/install.sh

COPY config.json /etc/config.json
COPY config-template.json /etc/config-template.json

RUN echo '#!/bin/bash' > /app/startup.sh && \
    echo '' >> /app/startup.sh && \
    echo 'echo ""' >> /app/startup.sh && \
    echo 'echo "G2Ray - Configurable VLESS Proxy"' >> /app/startup.sh && \
    echo 'echo "================================"' >> /app/startup.sh && \
    echo 'echo ""' >> /app/startup.sh && \
    echo 'UUID="${G2RAY_UUID:-550e8400-e29b-41d4-a716-446655440000}"' >> /app/startup.sh && \
    echo 'PORT="${G2RAY_PORT:-443}"' >> /app/startup.sh && \
    echo 'NETWORK="${G2RAY_NETWORK:-xhttp}"' >> /app/startup.sh && \
    echo 'PATH_VAL="${G2RAY_PATH:-/}"' >> /app/startup.sh && \
    echo 'SNI="${G2RAY_SNI:-ghcr.io}"' >> /app/startup.sh && \
    echo 'TLS="${G2RAY_TLS:-true}"' >> /app/startup.sh && \
    echo 'MODE="${G2RAY_MODE:-packet-up}"' >> /app/startup.sh && \
    echo 'FRAG="${G2RAY_FRAGMENT:-false}"' >> /app/startup.sh && \
    echo 'FRAG_LEN="${G2RAY_FRAG_LEN:-100-200}"' >> /app/startup.sh && \
    echo 'FRAG_INT="${G2RAY_FRAG_INT:-10-20}"' >> /app/startup.sh && \
    echo 'REALITY="${G2RAY_REALITY:-false}"' >> /app/startup.sh && \
    echo 'REALITY_PK="${G2RAY_REALITY_PK:-}"' >> /app/startup.sh && \
    echo 'REALITY_SID="${G2RAY_REALITY_SID:-}"' >> /app/startup.sh && \
    echo 'REALITY_SNI="${G2RAY_REALITY_SNI:-}"' >> /app/startup.sh && \
    echo 'HOST_IP="${G2RAY_HOST:-94.130.50.12}"' >> /app/startup.sh && \
    echo 'CODESPACE="${CODESPACE_NAME:-g2ray}"' >> /app/startup.sh && \
    echo 'FP="${G2RAY_FP:-chrome}"' >> /app/startup.sh && \
    echo 'WS_EARLY="${G2RAY_WS_EARLY:-true}"' >> /app/startup.sh && \
    echo 'WS_HOST="${G2RAY_WS_HOST:-example.com}"' >> /app/startup.sh && \
    echo 'WS_HEADERS="${G2RAY_WS_HEADERS:-{}}"' >> /app/startup.sh && \
    echo 'H2_HOST="${G2RAY_H2_HOST:-example.com}"' >> /app/startup.sh && \
    echo 'H2_PATH="${G2RAY_H2_PATH:-/}"' >> /app/startup.sh && \
    echo 'GRPC_SVC="${G2RAY_GRPC_SVC:-test}"' >> /app/startup.sh && \
    echo 'GRPC_MULTI="${G2RAY_GRPC_MULTI:-false}"' >> /app/startup.sh && \
    echo 'NOISE="${G2RAY_NOISE:-false}"' >> /app/startup.sh && \
    echo 'NOISE_PKT="${G2RAY_NOISE_PKT:-d200}"' >> /app/startup.sh && \
    echo 'NOISE_SRC="${G2RAY_NOISE_SRC:-}"' >> /app/startup.sh && \
    echo '' >> /app/startup.sh && \
    echo 'echo "Generating config with:" >> /app/startup.sh && \
    echo "  UUID: $UUID" >> /app/startup.sh && \
    echo "  Port: $PORT" >> /app/startup.sh && \
    echo "  Network: $NETWORK" >> /app/startup.sh && \
    echo "  SNI: $SNI" >> /app/startup.sh && \
    echo "  TLS: $TLS" >> /app/startup.sh && \
    echo "  Fragment: $FRAG" >> /app/startup.sh && \
    echo "  Reality: $REALITY" >> /app/startup.sh && \
    echo '' >> /app/startup.sh && \
    echo 'python3 /app/generate_config.py' >> /app/startup.sh && \
    echo '' >> /app/startup.sh && \
    echo 'echo ""' >> /app/startup.sh && \
    echo 'echo "VLESS Link:" >> /app/startup.sh && \
    echo "vless://$UUID@$HOST_IP:$PORT?encryption=none&type=$NETWORK&security=$([ $TLS = true ] && echo $([ $REALITY = true ] && echo reality || echo tls) || echo none)&sni=$SNI#$(echo G2Ray-$CODESPACE)" >> /app/startup.sh && \
    echo '' >> /app/startup.sh && \
    echo 'exec /usr/local/bin/xray -c /etc/g2ray-generated.json' >> /app/startup.sh && \
    chmod +x /app/startup.sh

CMD ["/app/startup.sh"]
