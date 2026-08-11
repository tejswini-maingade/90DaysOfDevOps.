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

echo "----------- Top 5 Error Messages -----------------"
top_err=$(grep "ERROR" $log_file | awk '{$1=$2=$3=""; print}' | sort | uniq -c | sort -rn | head -5)
echo "$top_err"
