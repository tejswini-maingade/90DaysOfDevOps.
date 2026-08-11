#!/bin/bash

# Define the check_disk function
check_disk(){
    echo "Disk Usage"
    df -h / | awk 'NR==2 {print "  Size: " $2, "Used: " $3, "Available: " $4}'
}

# Define the check_memory function
check_memory(){
    echo "Free Memory"
    free -h | awk 'NR==2 {print "  " $4 " free"}'
}

# Main function
main(){
	check_disk
	check_memory
}

# Calling main funtion
main