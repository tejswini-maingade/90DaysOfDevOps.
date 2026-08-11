#!/bin/bash

# 1. Check for two arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 /source/directory /backup/destination"
    exit 1
fi

SOURCE_DIR=$1
DEST_DIR=$2
TIMESTAMP=$(date +%Y-%m-%d)
BACKUP_NAME="backup-$TIMESTAMP.tar.gz"
FULL_PATH="$DEST_DIR/$BACKUP_NAME"

# 2. Exit if source doesn't exist
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory '$SOURCE_DIR' does not exist."
    exit 1
fi

# Create destination if it doesn't exist
mkdir -p "$DEST_DIR"

echo "Starting backup of $SOURCE_DIR..."

# 3. Create timestamped archive
# -c: create, -z: gzip, -f: file
tar -czf "$FULL_PATH" -C "$SOURCE_DIR" .

# 4. Verify success
if [ $? -eq 0 ]; then
    # 5. Print name and size (human-readable)
    FILE_SIZE=$(du -h "$FULL_PATH" | cut -f1)
    echo "Backup successful!"
    echo "Archive: $BACKUP_NAME"
    echo "Size:    $FILE_SIZE"
else
    echo "Error: Backup failed during compression."
    exit 1
fi

# 6. Delete backups older than 14 days in destination
echo "Cleaning up backups older than 14 days..."
find "$DEST_DIR" -type f -name "backup-*.tar.gz" -mtime +14 -delete

echo "Done."
