#!/bin/bash

# =========================
# CONFIGURATION
# =========================

PROJECT_NAME="my-project"
ZIP_NAME="${PROJECT_NAME}.zip"

SERVER_USER="ubuntu"
SERVER_HOST="43.204.240.239"
SERVER_PATH="/home/ubuntu"

SSH_KEY="/Users/abhishekkumar/Downloads/auto-deploy-frontend-test-key.pem"

# =========================
# SAFETY SETTINGS
# =========================

set -e

# =========================
# STEP 1: ZIP PROJECT
# =========================

echo "📦 Zipping project..."

rm -f "$ZIP_NAME"

zip -r "$ZIP_NAME" . \
  -x "node_modules/*" \
  -x ".git/*" \
  -x "*.zip"

echo "✅ Zip created: $ZIP_NAME"

# =========================
# STEP 2: SCP TO SERVER
# =========================

echo "🚀 Uploading zip to server..."

scp -i "$SSH_KEY" "$ZIP_NAME" "$SERVER_USER@$SERVER_HOST:$SERVER_PATH"

echo "✅ Zip uploaded successfully"

# =========================
# STEP 3: SSH + DEPLOY
# =========================

echo "🔐 Connecting to server and deploying..."

ssh -i "$SSH_KEY" "$SERVER_USER@$SERVER_HOST" << EOF
  set -e

  cd "$SERVER_PATH"

  echo "🧹 Cleaning old deployment..."
#   rm -rf "$PROJECT_NAME"
#   rm -f "$ZIP_NAME"

  echo "📦 Unzipping project..."
  unzip -o "$ZIP_NAME" -d "$PROJECT_NAME"

  cd "$PROJECT_NAME"

  echo "📥 Installing dependencies..."
  npm install

  echo "▶️ Starting application in screen session..."

  SCREEN_NAME="my-project-dev"

  # Kill old screen session if exists
  screen -S "\$SCREEN_NAME" -X quit || true

  # Start new screen session with Vite dev server
  screen -dmS "\$SCREEN_NAME" bash -c "npm run dev -- --host"

  echo "✅ App started in screen session: \$SCREEN_NAME"
EOF

echo "🎉 Deployment completed successfully!"