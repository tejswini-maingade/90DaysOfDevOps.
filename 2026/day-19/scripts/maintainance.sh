#!/bin/bash
# ^ This is the "executing argument" (Shebang) that tells Linux how to run the file.

# Assign the log path to a variable
MAINT_LOG="/var/log/maintenance.log"

# Get current time
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# Execute a maintenance task (e.g., clearing the /tmp folder)
echo "[$TIMESTAMP] Starting Maintenance..." >> "$MAINT_LOG"

# Clean up /tmp files older than 1 day
find /tmp -type f -atime +1 -delete 2>/dev/null

echo "[$TIMESTAMP] Maintenance Complete." >> "$MAINT_LOG"
echo "------------------------------------" >> "$MAINT_LOG"
