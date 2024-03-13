#!/bin/bash

# Function to read CPU statistics
read_cpu_stat() {
  cat /proc/stat | head -n 1 | awk '{print $2+$3+$4+$5+$6+$7+$8}'
}

# Function to read CPU idle time
read_cpu_idle() {
  cat /proc/stat | head -n 1 | awk '{print $5}'
}

# Read initial values
initial_total=$(read_cpu_stat)
initial_idle=$(read_cpu_idle)

# Wait for a second
sleep 1

# Read values again
final_total=$(read_cpu_stat)
final_idle=$(read_cpu_idle)

# Calculate differences
total_diff=$((final_total - initial_total))
idle_diff=$((final_idle - initial_idle))

# Calculate CPU usage
cpu_usage=$((100 * (total_diff - idle_diff) / total_diff))

echo "Overall CPU Usage: $cpu_usage%"
