#!/bin/bash
set -euo pipefail

# System Information Script

# Function to display hostname and OS information
system_info() {
    echo "=============== Hostname & OS Info ================"
    echo "HostName : $(hostname)"           # Displays the hostname of the system
    echo "Kernel   : $(uname -r)"         # Displays the kernel version
    echo "OS       : $(lsb_release -ds)"  # Displays the OS name and version
    echo
}

# Function to display system uptime
system_uptime() {
    echo "=============== System Uptime ====================="
    uptime                               # Shows how long the system has been running, users logged in, and load averages
    echo
}

# Function to display top 5 disk usage
disk_usage() {
    echo "=============== Top 5 Disk Usage =================="
    # df -h: human-readable disk usage
    # sort -hr -k5: sort by usage percentage (5th column) in descending order
    # head -n 6: show header + top 5 entries
    df -h | sort -hr -k5 | head -n 6
    echo
}

# Function to display memory usage
memory_usage() {
    echo "=============== Memory Usage ======================"
    # free -h: human-readable memory info
    # awk: extract second row (Mem:) and print used, free, and available memory
    free -h | awk 'NR==2 {print "Used: " $3 " | Free: " $4 " | Available: " $7}'
    echo
}

# Function to display top 5 CPU-consuming processes
top_cpu_processes() {
    echo "=============== Top 5 CPU Processes ==============="
    # ps -eo pid,comm,%cpu: list PID, command name, CPU usage for all processes
    # --sort=-%cpu: sort descending by CPU usage
    # head -n 6: show header + top 5 processes
    ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
    echo
}

# Main function to call all the above functions
main() {
    system_info
    system_uptime
    disk_usage
    memory_usage
    top_cpu_processes
}

# Call main to run the script
main