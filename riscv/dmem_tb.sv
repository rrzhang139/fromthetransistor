`timescale 1ns / 1ps

module dmem_tb;

    // Inputs
    reg clk;
    reg rst;
    reg [31:0] alu_result;
    reg [31:0] wdata;
    reg wmem;

    // Outputs
    wire [31:0] rdata;

    // Instantiate the Unit Under Test (UUT)
    dmem uut (
        .clk(clk),
        .rst(rst),
        .alu_result(alu_result),
        .wdata(wdata),
        .wmem(wmem),
        .rdata(rdata)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin
        $dumpfile("out/dmem.vcd");
        $dumpvars(0, dmem_tb);
        // Initialize Inputs
        rst = 1;
        alu_result = 0;
        wdata = 0;
        wmem = 0;

        // Apply Reset
        #100;
        rst = 0;
        #100;

        // Test Case: Write Data
        alu_result = 32'd10; // Example address
        wdata = 32'hA5A5A5A5; // Data to write
        wmem = 1; // Enable write
        #10; // Wait for a clock cycle
        wmem = 0; // Disable write

        // Test Case: Read Data
        #10; // Wait for a clock cycle
        if (rdata !== 32'hA5A5A5A5) begin
            $display("Test Failed: Data Mismatch. Expected: %h, Read: %h", 32'hA5A5A5A5, rdata);
        end else begin
            $display("Test Passed: Data Matched.");
        end

        // Additional test cases...

        // Complete the simulation
        $finish;
    end

endmodule
