@echo off
title ClickUp Desktop Commander Bridge
color 0A

echo ============================================
echo   ClickUp Desktop Commander Bridge
echo   Starting server + tunnel...
echo ============================================
echo.

echo [1/2] Starting Supergateway + Desktop Commander on port 8001...
start "Commander Server" cmd /k "npx -y supergateway --stdio \"npx -y @wonderwhy-er/desktop-commander\" --port 8001 --outputTransport streamableHttp --healthEndpoint /health"

echo Waiting 10 seconds for server to initialize...
timeout /t 10 /nobreak >nul

echo [2/2] Starting Cloudflare Tunnel...
start "Commander Tunnel" cmd /k "cloudflared tunnel --url http://localhost:8001"

echo.
echo ============================================
echo   DONE! Copy the tunnel URL and paste in
echo   ClickUp MCP settings with /mcp/ at the end
echo ============================================
echo.
pause
