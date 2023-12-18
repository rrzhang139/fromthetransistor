#!/bin/bash

# Check if a filename was provided
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <filename_without_extension> [additional_verilog_files...]"
    exit 1
fi

filename="$1"
shift # Remove the first argument, so $@ now contains only additional Verilog files

# Compile with iverilog
iverilog -g2012 -o "${filename}.out" "${filename}.v" "${filename}_tb.v" "$@"

# Check the exit status of iverilog
if [ $? -ne 0 ]; then
    echo "Compilation failed. Exiting."
    exit 1
fi

# Run the simulation
vvp "${filename}.out"

# Open the waveform viewer
gtkwave "${filename}.vcd"
