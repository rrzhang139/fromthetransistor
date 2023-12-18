#!/bin/bash

# Check if a filename was provided
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <filename_without_extension> [additional_verilog_files...]"
    exit 1
fi

filename="$1"
shift # Remove the first argument, so $@ now contains only additional Verilog files

# Compile with iverilog
# iverilog -g2012 -o "out/alu.out" alu.sv alu_tb.sv riscv_def.sv imem.sv dram.sv
# iverilog -g2012 -o "out/ctl.out" ctl.sv ctl_tb.sv riscv_def.sv imem.sv dram.sv
# iverilog -g2012 -o "out/dmem.out" dmem.sv dmem_tb.sv riscv_def.sv imem.sv dram.sv
# iverilog -g2012 -o "out/pc.out" pc.sv pc_tb.sv riscv_def.sv imem.sv dram.sv
# iverilog -g2012 -o "out/regfile.out" regfile.sv regfile_tb.sv riscv_def.sv imem.sv dram.sv
# iverilog -g2012 -o "out/immgen.out" immgen.sv immgen_tb.sv riscv_def.sv
iverilog -g2012 -o "out/${filename}.out" ${filename}.sv ${filename}_tb.sv pc.sv ctl.sv immgen.sv branchcmp.sv regfile.sv alu.sv dmem.sv imem.sv dram.sv riscv_def.sv

# Check the exit status of iverilog
if [ $? -ne 0 ]; then
    echo "Compilation failed. Exiting."
    exit 1
fi

# Run the simulation
vvp "out/${filename}.out"

# Open the waveform viewer
gtkwave "out/${filename}.vcd" 
