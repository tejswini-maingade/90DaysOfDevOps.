#!/bin/bash

set -euo pipefail

#Accept the path to a log file as a command-line argument
log_file="$1"

#Exit with a clear error message if no argument is provided
if [ $# -eq 0 ]; then
    echo "Error: No log file path provided."
    exit 1
fi

# Exit with a clear error message if the file doesn't exist
if [ ! -f "$log_file" ]; then
    echo "Error: $log_file does not exist"
    exit 1
fi

# Count the total number of lines in the log file
total_lines_processed=$(wc -l < "$log_file")

# Count the number of error messages
total_errors_count=$(grep -c "ERROR" "$log_file")

# Top 5 error 
top_errors=$(grep "ERROR" "$log_file" | awk '{$1=$2=$3=""; print}' | sort | uniq -c | sort -rn | head -5)

# List of critical events with line numbers
critical_events=$( grep -n "CRITICAL" "$log_file" | sed 's/^\([0-9]*\):/Line \1:/')

# Generate the summary report in a separate file
summary_report="log_report_$(date +%Y-%m-%d).txt" 
{
    echo "Date of analysis: $(date)"
    echo "Log file name: $log_file"
    echo "Total lines processed: $total_lines_processed"
    echo "Total error count: $total_errors_count"
    echo "------------ Top 5 Error Messages ------------"
    echo "$top_errors"
    echo ""
    echo "------------ Critical Events ------------"
    echo "$critical_events"
    echo ""

} | tee "$summary_report"

echo "Summary report generated: $summary_report"

# Create an archive/ directory if it doesn't exist
archive_dir="./archive"

if [ ! -d "$archive_dir" ]; then
    
    mkdir "$archive_dir"
    
fi

# Move the processed log file into archive/ after analysis
mv "$log_file" "$archive_dir/"

# Print a confirmation message
echo "$log_file" moved to "$archive_dir/"

echo "Log analysis completed."
