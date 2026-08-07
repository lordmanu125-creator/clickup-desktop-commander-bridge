# 🛠️ Troubleshooting

## Common Errors

### "Ops. Algo deu errado" in ClickUp

**Cause:** ClickUp cannot reach or validate your MCP endpoint.

**Fixes:**
1. Make sure the URL ends with `/mcp/` (trailing slash!)
2. Wait 10-15 seconds after tunnel creation before connecting in ClickUp
3. Confirm server is running (`Listening on port 8001` in terminal)
4. Try opening the tunnel URL in browser, should show something (not error)

### "Invalid values" when starting Supergateway

**Cause:** Wrong transport flag format.

**Fix:** Use `streamableHttp` (camelCase), NOT `streamable-http` (kebab-case).

```bash
# Wrong
--outputTransport streamable-http

# Right
--outputTransport streamableHttp
```

### Server opens and closes immediately

**Cause:** Trying to use Desktop Commander's native `--port` flag.

**Fix:** Desktop Commander doesn't support `--port` natively. You MUST use Supergateway as a wrapper.

### "Unable to reach origin service" in tunnel

**Cause:** Server not running when tunnel starts.

**Fix:** Always start the server FIRST, wait for `Listening on port 8001`, THEN start the tunnel.

### Assertion failed: ncrypto::CSPRNG

**Cause:** Node.js memory corruption, usually from RAM exhaustion.

**Fix:**
1. Kill all Node processes: `taskkill /F /IM node.exe`
2. Check RAM usage (this setup needs ~200MB free minimum)
3. Restart everything cleanly

### Port already in use (EADDRINUSE / errno 10048)

**Cause:** Previous server instance still running.

**Fix:**
```bash
# Find what's on port 8001
netstat -ano | findstr :8001

# Kill it
taskkill /F /PID <PID_NUMBER>

# Restart server
```

### Tunnel works but ClickUp says "connection failed"

**Cause:** Quick tunnels need a few seconds to propagate globally.

**Fix:** Wait 10-15 seconds after the tunnel URL appears, then try connecting in ClickUp.

## Performance Tips

- **Minimum RAM:** ~200MB for the full stack (Supergateway + Commander + Cloudflared)
- **Startup time:** ~10-15 seconds total
- **Tunnel URL changes every restart** (quick tunnels are ephemeral)
- Close other heavy apps if on 8GB RAM
- Desktop Commander spawns child processes for each command, monitor with Task Manager

## Known Limitations

- Quick tunnel URLs are temporary (die when terminal closes)
- No built-in authentication (use named tunnels with Cloudflare Access for production)
- Supergateway listens on 0.0.0.0 (all interfaces), not just localhost
- Each reconnect attempt from ClickUp may spawn new processes
