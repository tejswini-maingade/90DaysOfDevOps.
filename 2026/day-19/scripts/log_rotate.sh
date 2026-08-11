#!/bin/bash

# Check if directory argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <log_directory>"
    exit 1
fi

LOG_DIR=$1

# Exit with error if directory doesn't exist
if [ ! -d "$LOG_DIR" ]; then
    echo "Error: Directory $LOG_DIR does not exist."
    exit 1
fi

# 1. Count and compress .log files older than 7 days
COMPRESS_COUNT=$(find "$LOG_DIR" -name "*.log" -type f -mtime +7 | wc -l)
find "$LOG_DIR" -name "*.log" -type f -mtime +7 -exec gzip {} \;

# 2. Count and delete .gz files older than 30 days
DELETE_COUNT=$(find "$LOG_DIR" -name "*.gz" -type f -mtime +30 | wc -l)
find "$LOG_DIR" -name "*.gz" -type f -mtime +30 -exec rm -f {} \;

# Print results
echo "Log rotation completed."
echo "Files compressed: $COMPRESS_COUNT"
echo "Files deleted: $DELETE_COUNT"
