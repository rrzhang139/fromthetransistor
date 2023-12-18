// `timescale 1ns/1ps

module receiver_tb;

    // Parameters for testbench
    // TODO: T_CLK = BIT_PERIOD / SAMPLES_PER_BIT
    localparam T_CLK = 10; // Clock period in ns (50 MHz for example)
    // TODO: change to buad rate: BIT_PERIOD = 1 / baud rate
    localparam BIT_PERIOD = T_CLK * 16; // Oversample 16 times
    localparam HALF_BIT_PERIOD = BIT_PERIOD / 2;
    localparam DATA_BITS = 8;
    localparam START_BIT = 1'b0;
    localparam STOP_BIT = 1'b1;

    // Testbench variables
    reg rx_clk;
    reg rx_serial;
    reg reset;
    wire [7:0] rx_data;
    wire rx_done;

    // Instantiate the receiver module
    receiver uut (
        .rx_clk(rx_clk),
        .rx_serial(rx_serial),
        .reset(reset),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

    // Generate the rx_clk
    initial begin
        rx_clk = 1'b0;
        forever #(T_CLK/2) rx_clk = ~rx_clk;
    end

    // Test sequence
    initial begin
        $dumpfile("receiver.vcd");  // For waveform viewing
        $dumpvars(0, receiver_tb);

        // Initialize inputs
        rx_serial = 1'b1; // Idle level
        reset = 1'b1; // Begin in reset
        #(T_CLK * 2) reset = 1'b0; // Release reset

        // Start bit
        rx_serial = START_BIT; 
        #(BIT_PERIOD);
        
        // BIT_PERIOD = T_CLK

        // 1 2 3 4 5 6 7 8 T_CLK
        // Where we store the bit and moveto state, 

        // Send 10101010 => 0xAA
        send_bit(1'b1);
        send_bit(1'b0);
        send_bit(1'b1);
        send_bit(1'b0);
        send_bit(1'b1);
        send_bit(1'b0);
        send_bit(1'b1);
        send_bit(1'b0);

        // Stop bit
        rx_serial = STOP_BIT;
        #(BIT_PERIOD);

        // Check that receiver finished successfully
        if (rx_done && rx_data == 8'b01010101) begin
            $display("Test Passed, received data = %b", rx_data);
        end else begin
            $display("Test Failed, received data = %b", rx_data);
        end

        // End simulation
        $finish;
    end

    // Task to send bits
    task send_bit;
        input bit_to_send;
        begin
            rx_serial = bit_to_send;
            #(BIT_PERIOD);
        end
    endtask

endmodule
