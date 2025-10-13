#!/bin/bash
# MediCloudX Data Exporter - Usage Example
# 
# Build the binary:
make

# Run the exporter:
./medicloudx_exporter --bucket vvb7iqs8

# Show version:
./medicloudx_exporter --version

# The binary contains embedded AWS credentials that can be extracted through:
# - Static analysis (strings, objdump, ghidra)
# - Dynamic analysis (gdb, strace)
# - Reverse engineering tools
