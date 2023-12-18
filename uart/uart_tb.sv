`timescale 1ns/1ps

module uart_tb;

  reg pclk; // System clock
  reg reset; // Reset signal
  reg tx_start; // Signal to start transmission
  reg [7:0] data_in; // Data to be transmitted
  wire tx_line; // UART transmission line
  wire tx_busy; // UART is busy transmitting
  reg rx_serial; // External signal received by UART
  wire [7:0] rx_data; // Data received by UART
  wire rx_done; // UART has received a byte

  // Instantiate the UART module
  uart uart (
    .pclk(pclk),
    .reset(reset),
    .tx_start(tx_start),
    .data_in(data_in),
    .tx_line(tx_line),
    .tx_busy(tx_busy),
    .rx_serial(rx_serial),
    .rx_data(rx_data),
    .rx_done(rx_done)
  );

  // Clock generation
  initial begin
    pclk = 0;
    forever #5 pclk = ~pclk; // Generate a 100 MHz clock (10ns period)
  end

  // Simulate external RX line (loopback from TX line for testing)
  // In a real test, rx_serial would be driven by another source
  always @* begin
    rx_serial <= tx_line; // Use non-blocking assignment for proper simulation behavior
  end

  // Test sequence
  initial begin
    $dumpfile("uart.vcd");  // For waveform viewing
    $dumpvars(0, uart);

    // Initialize signals
    reset = 1;
    tx_start = 0;
    data_in = 8'h00;
    rx_serial = 1; // Idle state is high for UART

    // Reset sequence
    #100; // Wait 100 ns for global reset
    reset = 0; // Release reset
    
    // Wait for a few clock cycles after reset
    #20;

    // Transmit a byte
    data_in = 8'hA5; // Example data to transmit
    tx_start = 1;
    #10; // Hold start for one clock cycle
    tx_start = 0;

    // Wait until a byte is received
    wait (rx_done);
    #30; // Wait a bit more for any additional logic

    // Check if received data matches transmitted data
    if (rx_data == data_in) begin
      $display("Test Passed: Data transmitted and received correctly.");
    end else begin
      $display("Test Failed: Received data: %02h, Expected data: %02h", rx_data, data_in);
    end

    // Finish the test
    $finish;
  end

endmodule
