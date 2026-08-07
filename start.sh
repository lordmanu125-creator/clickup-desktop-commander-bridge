#!/bin/bash

echo "============================================"
echo "  ClickUp Desktop Commander Bridge"
echo "  Starting server + tunnel..."
echo "============================================"
echo ""

# Start server in background
echo "[1/2] Starting Supergateway + Desktop Commander on port 8001..."
npx -y supergateway --stdio "npx -y @wonderwhy-er/desktop-commander" --port 8001 --outputTransport streamableHttp --healthEndpoint /health &
SERVER_PID=$!

echo "Waiting 10 seconds for server to initialize..."
sleep 10

# Start tunnel
echo "[2/2] Starting Cloudflare Tunnel..."
cloudflared tunnel --url http://localhost:8001 &
TUNNEL_PID=$!

echo ""
echo "============================================"
echo "  DONE! Copy the tunnel URL and paste in"
echo "  ClickUp MCP settings with /mcp/ at the end"
echo "============================================"
echo ""
echo "Press Ctrl+C to stop both processes"

# Trap to kill both on exit
trap "kill $SERVER_PID $TUNNEL_PID 2>/dev/null; exit" INT TERM
wait
