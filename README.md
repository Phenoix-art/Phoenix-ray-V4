# G2Ray - Configurable VLESS Proxy

Run a VLESS proxy on GitHub Codespaces. Full customization via web UI.

## How It Works

GitHub Codespaces runs a container that exposes port 443. GitHub's port-forwarder issues TLS certs for `<codespace-name>-443.app.github.dev`. The VLESS proxy listens on port 443 inside the codespace, and clients connect to a server IP with SNI pointing to the codespace domain.

## Setup Step by Step

### Step 1: Create a secondary GitHub account

G2Ray uses significant codespace hours. Use a separate account to avoid affecting your main account.

1. Go to github.com
2. Sign up for a new account (or use an existing secondary one)

### Step 2: Fork this repository

1. Navigate to your fork on GitHub
2. Click the green **Code** button
3. Switch to the **Codespaces** tab

### Step 3: Create a Codespace

1. Click **Create codespace on main**
2. Wait 2-5 minutes for the container to build and Xray to install
3. The terminal will show progress

### Step 4: Get your VLESS link

After startup, the terminal prints:
```
======================================
VLESS Connection Link:
======================================
vless://UUID@94.130.50.12:443?encryption=none&type=xhttp&security=tls&sni=mycodespace-443.app.github.dev#G2Ray-mycodespace
```

Copy this entire line.

### Step 5: Import into your client

Paste the link into:
- **V2RayNG** (Android): Settings -> Import from clipboard
- **Clash Meta**: Profiles -> Add from clipboard
- **Nekoray** (Desktop): Settings -> Add server from clipboard

### Step 6: Use the Web UI (optional)

The web configurator runs on port 3000. Click the forwarded port link in Codespaces to access it. From there you can:
- Customize every parameter
- Generate multiple configs
- Export QR codes
- Save profiles

## SNI Explained

The SNI is the domain that GitHub's port-forwarder uses for your codespace. Format:

```
<CODESPACE_NAME>-<PORT>.app.github.dev
```

Example: Your codespace is named `g2ray-myfork-main-abc123`, port is 443:
```
SNI = g2ray-myfork-main-abc123-443.app.github.dev
```

The TLS cert issued by GitHub covers this exact domain. Your VLESS client must use this SNI to validate the certificate when connecting to the server IP.

## Environment Variables

Set these in Settings > Codespaces > Configure to customize:

| Variable | Default | Description |
|----------|---------|-------------|
| G2RAY_UUID | auto | Custom UUID (v4 format) |
| G2RAY_PORT | 443 | Listening port |
| G2RAY_NETWORK | xhttp | Transport: xhttp, ws, h2, grpc |
| G2RAY_PATH | / | Path for ws/h2/xhttp transport |
| G2RAY_TLS | true | Enable TLS |
| G2RAY_REALITY | false | Use REALITY mode |
| G2RAY_FRAGMENT | false | Enable fragment mode |
| G2RAY_FRAG_LEN | 100-200 | Fragment packet length range |
| G2RAY_FRAG_INT | 10-20 | Fragment interval range |
| G2RAY_HOST | 94.130.50.12 | Server IP to connect to |
| G2RAY_FP | chrome | TLS fingerprint |

## Recommended Configurations

### Shecan (Iran) - Basic
- Network: xhttp
- Port: 443
- TLS: enabled
- SNI: auto (codespace-name-443.app.github.dev)

### Shecan (Iran) - Fragment
- Same as basic + Fragment enabled
- Fragment: 100-200, 10-20

### TciNet (Iran) - WebSocket
- Network: ws
- Path: /
- Early Data: enabled
- SNI: auto

### International - gRPC
- Network: grpc
- Service Name: test
- TLS: enabled

## Stopping/Restarting

To stop the codespace (saves your hours):
1. Click the Codespaces icon in GitHub sidebar
2. Right-click your codespace -> Stop

To restart:
1. Click the Codespaces icon
2. Click Start on your codespace

## Troubleshooting

### Connection times out
- Try different network transport (ws, h2, grpc)
- Enable fragment mode
- Change HOST to a different IP

### TLS certificate error
- Verify SNI matches `<name>-443.app.github.dev`
- Set allowInsecure in your client

### Slow speeds
- Use xhttp-go mode
- Reduce fragment packet size
- Try HTTP/2 transport

### Codespace won't start
- Check codespace quota (120 hours/month free)
- Stop any running codespaces
