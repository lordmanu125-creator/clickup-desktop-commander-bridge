# 🔌 ClickUp Desktop Commander Bridge

> Connect [Desktop Commander MCP](https://github.com/wonderwhy-er/desktop-commander) to [ClickUp Brain](https://clickup.com/ai) via Supergateway + Cloudflare Tunnel.

**The first open-source guide to bridge any stdio MCP server to ClickUp's streamableHttp transport.**

## 🧠 What is this?

ClickUp Brain supports connecting to external MCP (Model Context Protocol) servers. However, most MCP servers (like Desktop Commander) use **stdio** transport, while ClickUp only speaks **streamableHttp**.

This project solves that gap using:
- **[Supergateway](https://github.com/nicepkg/supergateway)** — translates stdio ↔ streamableHttp
- **[Cloudflare Tunnel](https://developers.cloudflare.com/cloudflare-one/)** — exposes your local server to the internet securely
- **Desktop Commander** — gives ClickUp Brain full access to your terminal, files, and processes

## ⚡ Quick Start

### Prerequisites
- Node.js 20+ installed
- [Cloudflared](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/downloads/) installed
- ClickUp workspace with Brain enabled

### 1. Start the server

```bash
npx -y supergateway --stdio "npx -y @wonderwhy-er/desktop-commander" --port 8001 --outputTransport streamableHttp --healthEndpoint /health
```

Wait for: `Listening on port 8001`

### 2. Create the tunnel

```bash
cloudflared tunnel --url http://localhost:8001
```

Copy the generated URL (e.g., `https://random-words.trycloudflare.com`)

### 3. Connect to ClickUp

1. Go to **Settings → Integrations → MCP Servers → Add**
2. Name: `Desktop Commander` (or whatever you want)
3. URL: `https://your-tunnel-url.trycloudflare.com/mcp/` ⚠️ **trailing slash required!**
4. Authentication: **None**
5. Click **Next** → ClickUp validates the connection
6. Done! Brain now has terminal access to your machine.

## 🪟 Windows Quick Start (BAT script)

Use the provided `start.bat` to launch everything in one click:

```bash
start.bat
```

This opens two terminals: one for the server, one for the tunnel.

## 🐧 Linux/Mac Quick Start

```bash
chmod +x start.sh
./start.sh
```

## 🚨 Critical Discoveries (What Nobody Tells You)

| Problem | Wrong | Right |
|---------|-------|-------|
| Transport flag | `--outputTransport streamable-http` | `--outputTransport streamableHttp` (camelCase!) |
| ClickUp endpoint | `/sse` or `/` | `/mcp/` (with trailing slash) |
| Transport type | SSE | streamableHttp (SSE does NOT work with ClickUp) |
| Direct Desktop Commander | `--port 8001` flag | Doesn't work, needs Supergateway wrapper |
| Tunnel target | `https://localhost:8001` | `http://localhost:8001` (no TLS locally) |

## 🏗️ Architecture

```
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐     ┌──────────────┐
│  ClickUp Brain  │────▶│ Cloudflare Tunnel │────▶│  Supergateway   │────▶│   Desktop    │
│  (cloud)        │     │  (trycloudflare) │     │  (port 8001)    │     │  Commander   │
│                 │◀────│                  │◀────│  streamableHttp │◀────│  (stdio)     │
└─────────────────┘     └──────────────────┘     └─────────────────┘     └──────────────┘
```

## 📁 Project Structure

```
├── README.md           # This file
├── start.bat           # Windows launcher
├── start.sh            # Linux/Mac launcher
├── docs/
│   ├── TROUBLESHOOTING.md  # Common errors and fixes
│   └── SECURITY.md         # Security considerations
└── examples/
    └── clickup-config.md   # ClickUp MCP configuration examples
```

## 🔐 Security Notes

- The tunnel URL changes every restart (quick tunnel, no account needed)
- Supergateway listens on `0.0.0.0` by default (accessible on LAN)
- No authentication on the MCP endpoint (acceptable for personal use)
- For production: use a named Cloudflare Tunnel with access policies

## 🤝 Works With Any MCP Server

While this guide uses Desktop Commander, the same pattern works for **any stdio MCP server**:

```bash
npx -y supergateway --stdio "YOUR_MCP_COMMAND_HERE" --port 8001 --outputTransport streamableHttp --healthEndpoint /health
```

Examples:
- `npx -y @anthropic/mcp-server-filesystem /path/to/dir`
- `npx -y @anthropic/mcp-server-github`
- Any custom MCP server

## 📊 Tested Environment

- Windows 11 Pro (build 26200)
- Node.js v26.4.0
- Supergateway v3.4.3
- Desktop Commander v0.2.47
- Cloudflared 2026.7.3
- ClickUp Brain MAX (Unlimited plan)

## 🙏 Credits

- [Desktop Commander](https://github.com/wonderwhy-er/desktop-commander) by @wonderwhy-er
- [Supergateway](https://github.com/nicepkg/supergateway) by nicepkg
- [Cloudflare Tunnel](https://developers.cloudflare.com/cloudflare-one/) by Cloudflare
- Discovered and documented by [@lordmanu125-creator](https://github.com/lordmanu125-creator)

## 📝 License

MIT
