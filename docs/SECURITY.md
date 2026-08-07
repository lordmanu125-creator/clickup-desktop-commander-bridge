# 🔐 Security Considerations

## What this exposes

When you run this bridge, you're giving ClickUp Brain (and anyone with the tunnel URL) full access to:
- Execute terminal commands on your machine
- Read, write, and delete files
- Start and stop processes
- Search file contents

## Risk Levels

### Quick Tunnel (default, what this repo uses)

| Factor | Risk | Notes |
|--------|------|-------|
| URL guessability | Low | Random 4-word URL, changes every restart |
| Authentication | None | Anyone with URL can access |
| Persistence | None | Dies when terminal closes |
| Network exposure | Internet | URL is publicly accessible |

**Acceptable for:** Personal use, development, experimentation.

### Named Tunnel (production recommendation)

For persistent, secure access:

1. Create a Cloudflare account
2. Set up a named tunnel with a fixed subdomain
3. Add Cloudflare Access policies (email auth, IP allowlist, etc.)
4. Run cloudflared as a service

## Hardening Tips

1. **Don't leave it running unattended** (quick tunnel = close terminal when done)
2. **Monitor active processes** on your machine while connected
3. **Use Desktop Commander's blockedCommands** to restrict dangerous operations:
   - `format`, `diskpart`, `shutdown`, `reboot` are blocked by default
   - Add more via `set_config_value` tool
4. **Restrict allowed directories** if you don't need full filesystem access
5. **Don't share the tunnel URL** (treat it like a password while it's active)

## Supergateway 0.0.0.0 Binding

By default, Supergateway binds to `0.0.0.0:8001`, meaning any device on your local network can reach it. This is usually fine behind a home router, but be aware:

- Other devices on your WiFi can hit `http://YOUR_IP:8001/mcp/`
- If you're on a public network, this is a risk
- There's no flag to force localhost-only binding in Supergateway currently

## Emergency: Someone Has Your URL

1. Close the tunnel terminal (kills the URL instantly)
2. Kill node processes: `taskkill /F /IM node.exe`
3. Check for unauthorized file changes
4. Restart with a fresh tunnel (new URL)
