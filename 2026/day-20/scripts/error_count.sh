#!/bin/bash

# Accept the path to a log file as a command-line argument
log_file="$1"

# Exit with a clear error message if no argument is provided
if [ $# -eq 0 ]; then
    echo "Error: No log file path provided."
    exit 1
fi

# Exit with a clear error message if the file doesn't exist
if [ ! -f "$log_file" ]; then
    echo "Error: File does not exists: $log_file"
    exit 1
fi

# Count the total number of lines containing the keyword ERROR
error_count=$(grep -c "ERROR" "$log_file")

# Print the total error count to the console
echo "Total ERROR count: $error_count"
