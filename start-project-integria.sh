#!/bin/bash

# Exit immediately if a command fails
set -e

# -----------------------------
# CONFIG (change if needed)
# -----------------------------

PROJECT_DIR="$HOME/path/to/your/project"
FRONTEND_DIR="$PROJECT_DIR/frontend"
BACKEND_DIR="$PROJECT_DIR/backend"

FRONTEND_CMD="npm run dev"
BACKEND_CMD="php artisan serve --host=0.0.0.0"

URL="http://localhost:3000"

# -----------------------------
# OPEN PROJECT IN VS CODE
# -----------------------------
# echo "Opening VS Code..."
# cd "$PROJECT_DIR"
# code .
echo "Opening VS Code..."
cd "$PROJECT_DIR" || exit
code . || echo "⚠️ VS Code not found in PATH"


# -----------------------------
# START BACKEND
# -----------------------------
# echo "Starting backend..."
# cd "$BACKEND_DIR"
# osascript -e "tell application \"Terminal\" to do script \"cd $BACKEND_DIR && $BACKEND_CMD\""

# -----------------------------
# START FRONTEND
# -----------------------------
# echo "Starting frontend..."
# cd "$FRONTEND_DIR"
# osascript -e "tell application \"Terminal\" to do script \"cd $FRONTEND_DIR && $FRONTEND_CMD\""
# -----------------------------
# START BACKEND (new Terminal tab)
# -----------------------------
osascript <<EOF
tell application "Terminal"
    activate
    do script "cd $BACKEND_DIR && $BACKEND_CMD"
end tell
EOF

# -----------------------------
# START FRONTEND (new Terminal tab)
# -----------------------------
osascript <<EOF
tell application "Terminal"
    do script "cd $FRONTEND_DIR && $FRONTEND_CMD"
end tell
EOF
# -----------------------------
# WAIT FOR SERVERS TO START
# -----------------------------
echo "Waiting for servers to start..."
sleep 5

# -----------------------------
# OPEN BROWSERS
# -----------------------------
echo "Opening browsers..."

open -a "Microsoft Edge" "$URL"
open -a "Firefox" "$URL"
open -a "Firefox Developer Edition" "$URL"
open -a "Brave Browser" "$URL"

echo "✅ Project started successfully"
