# 📝 ClickUp MCP Configuration Examples

## Desktop Commander (Terminal + Files)

```
Name: Desktop Commander
URL: https://your-tunnel-url.trycloudflare.com/mcp/
Authentication: None
```

**Server command:**
```bash
npx -y supergateway --stdio "npx -y @wonderwhy-er/desktop-commander" --port 8001 --outputTransport streamableHttp --healthEndpoint /health
```

## Google Sheets MCP (Spreadsheet access)

```
Name: Google Sheets
URL: https://your-tunnel-url.trycloudflare.com/mcp/
Authentication: None
```

**Server command:**
```bash
mcp-google-sheets --transport streamable-http --port 8000
```

**Tunnel:**
```bash
cloudflared tunnel --url http://localhost:8000
```

**Note:** Requires `GOOGLE_APPLICATION_CREDENTIALS` environment variable set to service account JSON path.

## Obsidian (Knowledge Base)

```
Name: Obsidian
URL: https://your-tunnel-url.trycloudflare.com/mcp/
Authentication: Header
Header: Authorization
Value: Bearer YOUR_LOCAL_REST_API_KEY
```

**Tunnel (no server needed, plugin runs in Obsidian):**
```bash
cloudflared tunnel --url https://127.0.0.1:27124 --no-tls-verify
```

**Note:** Requires Obsidian plugin "Local REST API" enabled on port 27124.

## Generic stdio MCP Server

Any MCP server that uses stdio transport can be bridged:

```bash
npx -y supergateway --stdio "YOUR_COMMAND_HERE" --port PORT --outputTransport streamableHttp --healthEndpoint /health
```

Then tunnel it:
```bash
cloudflared tunnel --url http://localhost:PORT
```

And connect in ClickUp with `/mcp/` at the end of the tunnel URL.

## Multiple MCPs at Once

You can run multiple bridges on different ports:

| MCP | Port | Tunnel |
|-----|------|--------|
| Desktop Commander | 8001 | Tunnel 1 |
| Google Sheets | 8000 | Tunnel 2 |
| Obsidian | 27124 | Tunnel 3 |
| Custom MCP | 8002 | Tunnel 4 |

Each needs its own terminal pair (server + tunnel) and its own ClickUp MCP entry.
