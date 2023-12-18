module tb_full_adder;

  reg A, B, carry_in;
  wire sum_bit, carry_out;

  // Instantiate the full_adder module
  full_adder uut (
      .A(A),
      .B(B),
      .carry_in(carry_in),
      .sum_bit(sum_bit),
      .carry_out(carry_out)
  );

  // Testbench logic
  initial begin
    // Open the waveform dump file
    $dumpfile("full_adder.vcd");
    $dumpvars(0, tb_full_adder);
    
    // Test case 1: A=0, B=0, carry_in=0
    A = 0; B = 0; carry_in = 0;
    #10; // Delay to see the result in the waveform

    // Test case 2: A=0, B=0, carry_in=1
    carry_in = 1;
    #10;

    // Test case 3: A=0, B=1, carry_in=0
    B = 1; carry_in = 0;
    #10;

    // A=0, B=1, C=1
    carry_in = 1;
    #10

    // A=1, B=0, cin=0
    A = 1; B = 0; carry_in = 0;
    #10

    // Test case 2: A=1, B=0, carry_in=1
    carry_in = 1;
    #10;

    // Test case 3: A=1, B=1, carry_in=0
    B = 1; carry_in = 0;
    #10;

    // Test case 8: A=1, B=1, carry_in=1
    carry_in = 1;
    #10;

    $finish;  // End the simulation
  end
endmodule
