#!/bin/bash

# Check if argument is provided
if [ $# -eq 0 ]; then
    echo "Error: Please provide a log file path."
    echo "Usage: $0 <log_file>"
    exit 1
fi

LOG_FILE="$1"

# Check if file exists
if [ ! -f "$LOG_FILE" ]; then
    echo "Error: File '$LOG_FILE' does not exist."
    exit 1
fi

echo "Log file found: $LOG_FILE"
