`timescale 1ns / 1ps

module ctl_tb;

    `include "riscv_def.sv"

    // Inputs
    reg clk;
    reg rst;
    reg [31:0] idata;

    // Outputs
    wire [4:0] reg1, reg2, regd;
    wire [3:0] aluop;
    wire [2:0] inst_format
    wire inst_undef;
    wire wreg, rmem, wmem, wbsel, pcsel, bsel;

    // Instantiate the Unit Under Test (UUT)
    ctl uut (
        .clk(clk),
        .rst(rst),
        .idata(idata),
        .reg1(reg1),
        .reg2(reg2),
        .regd(regd),
        .aluop(aluop),
        .inst_format(inst_format),
        .inst_undef(inst_undef),
        .wreg(wreg),
        .rmem(rmem),
        .wmem(wmem),
        .wbsel(wbsel),
        // .pcsel(pcsel),
        .bsel(bsel)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin
        $dumpfile("out/ctl.vcd");
        $dumpvars(0, ctl_tb);
        // Initialize Inputs
        rst = 1;
        idata = 0;
        #10; // Wait for reset
        rst = 0;

        // Test Case 1: ADD instruction (R-type)
        idata = 32'b0000000_01010_01001_000_01011_0110011; // Corrected ADD instruction: add reg11, reg9, reg10
        #10; // Wait for a clock cycle

        // Check control signals
        if (aluop !== AluOp_ADD || wreg !== 1'b1 || inst_format !== InstFormat_R) begin
            $display("Test Failed for ADD instruction");
        end else begin
            $display("Test Passed for ADD instruction");
        end

        // Test Case 2: SUB instruction (R-type)
        // Test Case: Subtraction instruction (R-type)
        //          |  f7 |   r2    r1   f3   rd    op
        idata = 32'b0100000_01010_01001_000_01011_0110011; // Corrected SUB instruction: sub reg11, reg9, reg10
        #10; // Wait for a clock cycle

        // Check control signals
        if (aluop !== AluOp_SUB || wreg !== 1'b1 || inst_format !== InstFormat_R) begin
            $display("Test Failed for SUB instruction");
        end else begin
            $display("Test Passed for SUB instruction");
        end

        // Complete the simulation
        $finish;
    end

endmodule
