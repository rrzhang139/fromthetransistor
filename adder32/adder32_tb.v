module tb_adder32;

  // Input drivers
  reg [31:0] A, B;
  reg ALUFN;
  wire [31:0] sum_out;
  wire Z, V, N;

  adder32 uut (
    .A(A),
    .B(B),
    .ALUFN(ALUFN),
    .sum(sum_out),
    .Z(Z),
    .V(V),
    .N(N)
  );

  // Testbench logic
  initial begin
    $dumpfile("adder32.vcd");
    $dumpvars(0, tb_adder32);

    // Test addition
    A = 32'b00000000000000000000000001010101;  
    B = 32'b00000000000000000000000000110011;    
    ALUFN = 0;         
    #10;

    // Test subtraction
    A = 32'b00000000000000000000000001010101;
    B = 32'b00000000000000000000000000110011;
    ALUFN = 1;
    #10;

    // Test overflow
    A = 32'h7FFFFFFF;
    B = 32'h00000001;
    ALUFN = 0;
    #10;

    // Test underflow
    A = 32'h80000000;
    B = 32'h00000001;
    ALUFN = 1;
    #10;

    // Test zero
    A = 32'h00000000;
    B = 32'h00000000;
    ALUFN = 0;
    #10;

    // Test negative
    A = 32'h80000000;
    B = 32'h00000001;
    ALUFN = 0;
    #10;

    $finish;
  end

endmodule