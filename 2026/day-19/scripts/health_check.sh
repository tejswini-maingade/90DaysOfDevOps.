#!/bin/bash

echo "===== Health Check ====="
echo "Date: $(date)"
echo "Hostname: $(hostname)"
echo "Uptime: $(uptime)"
echo "Disk Usage:"
df -h /
echo "======================="
