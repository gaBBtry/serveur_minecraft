#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: ./restore.sh backups/<backup-file>.tar.gz"
  exit 1
fi

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
ARCHIVE_PATH="$1"

if [[ ! -f "$ARCHIVE_PATH" ]]; then
  echo "[ERROR] Backup file not found: $ARCHIVE_PATH"
  exit 1
fi

echo "[WARN] This will replace current data/ with backup contents."
echo "[INFO] Stopping server..."
docker compose -f "$PROJECT_DIR/docker-compose.yml" stop mc-server

if [[ -d "$PROJECT_DIR/data" ]]; then
  rm -rf "$PROJECT_DIR/data"
fi

echo "[INFO] Restoring from: $ARCHIVE_PATH"
tar -xzf "$ARCHIVE_PATH" -C "$PROJECT_DIR"

echo "[INFO] Starting server..."
docker compose -f "$PROJECT_DIR/docker-compose.yml" up -d mc-server

echo "[INFO] Restore completed."
