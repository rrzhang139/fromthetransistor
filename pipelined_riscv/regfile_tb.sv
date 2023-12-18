`timescale 1ns / 1ps

module regfile_tb;

    reg clk, wreg;
    reg [4:0] waddr, raddr1, raddr2;
    reg [31:0] wrdata;
    wire [31:0] rdata1, rdata2;

    // Instantiate the Register File
    regfile uut (
        .clk(clk),
        .wreg(wreg),
        .waddr(waddr),
        .raddr1(raddr1),
        .raddr2(raddr2),
        .wrdata(wrdata),
        .rdata1(rdata1),
        .rdata2(rdata2)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        $dumpfile("out/regfile.vcd");
        $dumpvars(0, regfile_tb);
        // Initialize Inputs
        wreg = 0;
        waddr = 0;
        raddr1 = 0;
        raddr2 = 0;
        wrdata = 0;

        // Wait for global reset
        #100;

        // Test Case 1: Write and then Read from a Register
        wreg = 1;
        waddr = 5; // Write to register 5
        wrdata = 32'hA5A5A5A5; // Data to write
        #10; // Wait for a clock cycle
        wreg = 0;
        raddr1 = 5; // Read from register 5
        #10; 

        // Additional test cases...

        // Complete the simulation
        $finish;
    end

endmodule
