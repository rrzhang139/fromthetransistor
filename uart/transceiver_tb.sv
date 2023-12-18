`timescale 1ns/1ps

module transceiver_tb;

  localparam CLK_PERIOD = 160; // Clock period in ns

  // Common clock for both transmitter and receiver
  reg clk;
  reg clk_rcvr;
  reg reset;
  reg framing_error;
  
  // Transmitter signals
  reg tx_start;
  reg [7:0] data_in;
  wire tx_line;
  wire tx_busy;
  
  // Receiver signals
  wire [7:0] rx_data;
  wire rx_done;

  // Connect the transmitter output to the receiver input
  wire rx_serial = tx_line;

  // Instantiate the transmitter
  transmitter tx_uut (
      .clk(clk),
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

  // Clock generation for transmitter
  initial begin
      clk = 0;
      forever #(CLK_PERIOD/2) clk = ~clk; // Generate a clock with a period of 10ns
  end
  initial begin
      clk_rcvr = 0;
      forever #(CLK_PERIOD/32) clk_rcvr = ~clk_rcvr; // Generate a clock with a period of 0.625ns
  end

  // Test sequence
  initial begin
      $dumpfile("transceiver.vcd");
      $dumpvars(1, tx_uut);
      $dumpvars(1, rx_uut);

      // Initialize signals
      reset = 1;
      tx_start = 0;
      data_in = 8'b00000000;

      // Reset sequence
      #(CLK_PERIOD/2) reset = 0;

      // Transmit data sequence
      data_in = 8'b01001101; // Example data to transmit
      tx_start = 1; // Start the transmission
      #(CLK_PERIOD) tx_start = 0; // Release the tx_start signal

      // Wait for transmission to complete and receiver to capture the data
      wait(rx_done);
      // #3600;

      // Check if transmitted data matches received data
      if (rx_data == data_in) begin
          $display("Test Passed: Data transmitted and received correctly.");
      end else begin
          $display("Test Failed: Data mismatch. Transmitted: %0b, Received: %0b", data_in, rx_data);
      end

      // Finish the simulation
      $finish;
  end

endmodule
