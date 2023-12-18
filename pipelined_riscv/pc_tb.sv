`timescale 1ns / 1ps

module pc_tb;

    // Inputs
    reg clk;
    reg rst;

    // Outputs
    reg [31:0] iout;
    // reg [31:0] data;

    // Instantiate the Unit Under Test (UUT)
    pc uut (
        .clk(clk), 
        .rst(rst), 
        .iout(iout)
    );

    initial begin
        $dumpfile("out/pc.vcd");
        $dumpvars(0, pc_tb);
        clk = 0;

        // Clock generation
        forever begin
            #5;
            clk = ~clk;
        end
    end

    // Test sequence
    initial begin
        // Initialize Inputs
        rst = 1;

        // Wait for the global reset
        #10;
        
        // Release the reset
        rst = 0;

        // Complete the simulation
        $finish;
    end

endmodule
