#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$PROJECT_DIR/backups"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
ARCHIVE_NAME="minecraft-data-$TIMESTAMP.tar.gz"
ARCHIVE_PATH="$BACKUP_DIR/$ARCHIVE_NAME"

mkdir -p "$BACKUP_DIR"

echo "[INFO] Preparing world save..."
if docker compose -f "$PROJECT_DIR/docker-compose.yml" ps --status running --services | rg -x "mc-server" >/dev/null 2>&1; then
  docker compose -f "$PROJECT_DIR/docker-compose.yml" exec -T mc-server rcon-cli "save-all flush" >/dev/null 2>&1 || true
fi

echo "[INFO] Creating archive: $ARCHIVE_PATH"
tar -czf "$ARCHIVE_PATH" -C "$PROJECT_DIR" data

echo "[INFO] Backup created."

# Keep only 14 latest backups
mapfile -t backups < <(ls -1t "$BACKUP_DIR"/minecraft-data-*.tar.gz 2>/dev/null || true)
if ((${#backups[@]} > 14)); then
  echo "[INFO] Pruning old backups..."
  for old_backup in "${backups[@]:14}"; do
    rm -f "$old_backup"
  done
fi

echo "[INFO] Done."
