// `timescale 1ns/1ps

module tb_transmitter;

    localparam CLK_PERIOD = 10; // Clock period in ns

    reg clk;          // Clock signal
    reg reset;        // Reset signal
    reg tx_start;     // Transmission start signal
    reg [7:0] data_in; // Input data
    wire tx_line;     // Transmit line output from UUT (Unit Under Test)
    wire tx_busy;     // Transmit busy signal output from UUT

    // Instantiate the transmitter
    transmitter UUT (
        .clk(clk),
        .reset(reset),
        .tx_start(tx_start),
        .data_in(data_in),
        .tx_line(tx_line),
        .tx_busy(tx_busy)
    );

    initial begin
        $dumpfile("transmitter.vcd");  // For waveform viewing
        $dumpvars(0, tb_transmitter);

        // Initialize signals
        clk = 0;
        reset = 1;
        tx_start = 0;
        data_in = 8'b00000000;

        // Reset sequence
        // We wait for 5ns because initially clk is 0, half cycle is 5ns, so rising edge we can switch 
        // states
        #(CLK_PERIOD/2) reset = 0;

        // Transmit data sequence
        // LSB will be transmitted first
        data_in = 8'b11001101;  // Change data input
        tx_start = 1;          // Start the transmission
        
        #(CLK_PERIOD)
        tx_start = 0;          // Release the tx_start signal in 10s 

        // Wait and observe the outputs
        #200;
        
        // Repeat transmission with different data to verify
        // #10 data_in = 8'b10101010;  
        // #10 tx_start = 1;          
        // #10 tx_start = 0;          

        // // Wait and observe
        // #200;

        $finish;  // End the simulation
    end

    // Clock generation
    always #(CLK_PERIOD/2) clk = ~clk;  

endmodule
