module baud_rate_generator #(
    parameter CLOCK_RATE = 100000000, // board internal clock (def == 100MHz)
    parameter BAUD_RATE = 9600
)(
    input wire clk,          // System clock
    output reg clk_tx,       // Transmitter clock
    output reg clk_rcvr,       // Receiver clock
    input wire reset         // Active-high reset
);
    // PCLK / Baud rate = 1,000,000 / 9600 ≈ 104.17
    // parameter DIVIDER = 104;  // Example: for 9600 baud with a 1MHz clock
    // parameter DIVIDER_16 = 6; // 104 / 16 = 6.5, so 6 is the closest integer
    parameter MAX_RATE_TX = CLOCK_RATE / (BAUD_RATE*100);
    parameter MAX_RATE_RX = MAX_RATE_TX / 16; // 16x oversample
    parameter RX_CNT_WIDTH = $clog2(MAX_RATE_RX);
    parameter TX_CNT_WIDTH = $clog2(MAX_RATE_TX);
    reg [TX_CNT_WIDTH - 1:0] counter_tx = 0;  
    reg [RX_CNT_WIDTH - 1:0] counter_rcvr = 0;

    initial begin
      clk_tx = 1'b0;
      clk_rcvr = 1'b0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter_tx <= 7'd0;
            counter_rcvr <= 7'd0;
            clk_tx <= 0;
            clk_rcvr <= 0;
        end else if (counter_tx == MAX_RATE_TX[TX_CNT_WIDTH-1:0]) begin
            counter_tx <= 7'd0;
            clk_tx <= ~clk_tx;  // Toggle the transmitter clock
        end else if (counter_rcvr == MAX_RATE_RX[RX_CNT_WIDTH-1:0]) begin
            counter_rcvr <= 7'd0;
            clk_rcvr <= ~clk_rcvr;  // Toggle the receiver clock
        end else begin
            counter_tx <= counter_tx + 1'b1;
            counter_rcvr <= counter_rcvr + 1'b1;
        end
    end

endmodule
