#!/bin/bash
# Database Backup Script for Fashion Mart
# This script backs up your database before making any changes

BACKUP_DIR="database/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/fashion_mart_backup_$TIMESTAMP.sql"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Database credentials
DB_USER="fashion_user"
DB_PASS="fashion_pass_2024"
DB_NAME="fashion_mart"

echo "========================================="
echo "Fashion Mart Database Backup"
echo "========================================="
echo "Starting backup at $(date)"
echo "Backup file: $BACKUP_FILE"
echo ""

# Create backup
mysqldump -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" > "$BACKUP_FILE" 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✅ Backup completed successfully!"
    echo "📁 Backup saved to: $BACKUP_FILE"
    echo "📊 Backup size: $(du -h "$BACKUP_FILE" | cut -f1)"
    echo ""
    echo "To restore this backup later, run:"
    echo "mysql -u $DB_USER -p$DB_PASS $DB_NAME < $BACKUP_FILE"
else
    echo "❌ Backup failed!"
    exit 1
fi

echo ""
echo "========================================="
echo "Recent backups:"
ls -lht "$BACKUP_DIR" | head -5
