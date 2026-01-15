#!/bin/bash

set -e  # Exit immediately if any command fails

echo "🚀 Starting frontend deployment..."

# ---------- CONFIG ----------
ENV_FILE=".env"
ENV_BACKUP=".env.backup.$(date +%Y%m%d%H%M%S)"
BUILD_DIR="dist"
ZIP_NAME="dist.zip"

SERVER_USER="ubuntu"
SERVER_HOST="your.server.ip"
SERVER_PATH="/var/www/frontend"
# ----------------------------

# 1️⃣ Backup existing .env
if [ -f "$ENV_FILE" ]; then
  echo "📦 Backing up existing .env to $ENV_BACKUP"
  cp $ENV_FILE $ENV_BACKUP
else
  echo "ℹ️ No existing .env found"
fi

# 2️⃣ Create new production .env
echo "📝 Creating production .env file"
cat <<EOF > $ENV_FILE
VITE_API_BASE_URL=https://api.yourdomain.com
VITE_ENV=production
VITE_APP_NAME=MyApp_production
EOF

# 3️⃣ Build frontend
echo "🏗️ Building frontend..."
npm run build

# 4️⃣ Zip dist folder
echo "📦 Zipping build folder..."
rm -f $ZIP_NAME
zip -r $ZIP_NAME $BUILD_DIR

# 5️⃣ Copy zip to server
echo "📤 Uploading to server..."
# scp $ZIP_NAME $SERVER_USER@$SERVER_HOST:$SERVER_PATH

# if [ $? -ne 0 ]; then
#   echo "❌ SCP failed: could not upload $ZIP_NAME to server"
# else
#   echo "✅ SCP successful"
# fi

# # 6️⃣ (Optional) Restore original .env
# if [ -f "$ENV_BACKUP" ]; then
#   echo "♻️ Restoring original .env"
#   mv $ENV_BACKUP $ENV_FILE
# fi

# Upload to server
if ! scp "$ZIP_NAME" "$SERVER_USER@$SERVER_HOST:$SERVER_PATH"; then
  echo "❌ SCP failed: restoring original .env"

  if [ -f "$ENV_BACKUP" ]; then
    mv "$ENV_BACKUP" "$ENV_FILE"
    echo "♻️ .env restored"
  fi

  exit 1
fi


echo "✅ Frontend deployment completed successfully!"
