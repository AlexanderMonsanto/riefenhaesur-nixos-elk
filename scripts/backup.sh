#!/bin/bash
set -e

BACKUP_DIR="./backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/backup-$DATE.tar.gz"

echo "Creating backup: $BACKUP_FILE"

mkdir -p "$BACKUP_DIR"

tar -czf "$BACKUP_FILE" \
    --exclude='backups' \
    --exclude='node_modules' \
    --exclude='.git' \
    data/ config/ secrets/secrets.yaml

echo "Backup created: $BACKUP_FILE"
