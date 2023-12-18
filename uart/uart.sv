// `timescale 1ns/1ps

module uart #(
    parameter CLOCK_RATE = 100000000, // board internal clock (def == 100MHz)
    parameter BAUD_RATE = 9600
)(
  input wire pclk, // system clock
  input wire reset,
  input wire tx_start,       // Signal to start transmission
  input wire [7:0] data_in,  // Data to be transmitted
  output wire tx_line,       // UART transmission line
  output wire tx_busy,       // UART is busy transmitting
  input wire rx_serial,  // External signal received by UART
  output wire [7:0] rx_data, // Data received by UART
  output wire rx_done,        // UART has received a byte
  output wire framing_error  // Framing error
);

  // Common clock for both transmitter and receiver
  reg clk_tx;
  reg clk_rcvr;

  // Receiver register 
  // wire [7:0] rx_data; // Data received by UART

  baud_rate_generator #(
    .CLOCK_RATE(CLOCK_RATE),
    .BAUD_RATE(BAUD_RATE)
  ) baud_gen (
    .clk(pclk),
    .clk_tx(clk_tx),
    .clk_rcvr(clk_rcvr),
    .reset(reset)
  );

  // Instantiate the transmitter
  transmitter tx_uut (
      .clk(clk_tx),
      .reset(reset),
      .tx_start(tx_start),
      .data_in(data_in),
      .tx_line(tx_line),
      .tx_busy(tx_busy)
  );

  // Instantiate the receiver
  receiver rx_uut (
      .rx_clk(clk_rcvr), // The receiver clock is 16 times faster than the transmitter clock
      .rx_serial(rx_serial),
      .reset(reset),
      .rx_data(rx_data),
      .rx_done(rx_done),
      .framing_error(framing_error)
  );

endmodule
