#!/bin/bash

set -e   # stop script if any command fails

ENV_FILE=".env"
ENV_TEMP=".env.temp"
ENV_PROD=".env.production"
DIST_DIR="dist"

# ==============================
# CHECK REQUIRED FILES
# ==============================
if [ ! -f "$ENV_FILE" ]; then
  echo ".env file not found ❌"
  exit 1
fi

if [ ! -f "$ENV_PROD" ]; then
  echo ".env.production file not found ❌"
  exit 1
fi

# ==============================
# BACKUP CURRENT .env
# ==============================
mv "$ENV_FILE" "$ENV_TEMP"
echo ".env moved to .env.temp ✅"

# ==============================
# USE PRODUCTION ENV
# ==============================
cp "$ENV_PROD" "$ENV_FILE"
echo ".env.production copied to .env ✅"

# ==============================
# RUN BUILD
# ==============================
echo "Starting build..."
npm run build

# ==============================
# RESTORE ORIGINAL .env
# ==============================
rm "$ENV_FILE"
mv "$ENV_TEMP" "$ENV_FILE"
echo "Original .env restored ✅"

# ==============================
# ZIP dist WITH DATE & TIME
# ==============================
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
ZIP_NAME="dist_$TIMESTAMP.zip"

zip -r "$ZIP_NAME" "$DIST_DIR" > /dev/null

echo "Zip created 🎉 → $ZIP_NAME"

# ==============================
# OPEN PROJECT FOLDER (WINDOWS)
# ==============================
echo "Opening project folder 📂"
explorer.exe .