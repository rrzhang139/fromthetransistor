module tb;
    reg clk = 0;
    wire led = 0;

    // Instantiate the blinking_led module
    blinking_led uut (
        .clk(clk),
        .led(led)
    );

    // Clock generation
    
    always #5 clk = ~clk;
    

    // Testbench logic
    initial begin
        $dumpfile("blinking_led.vcd");
        $dumpvars(0, tb);

        clk = 0;
        #100000 $finish;
    end
endmodule

