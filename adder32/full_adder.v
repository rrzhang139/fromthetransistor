module full_adder (
  input wire A, // 1 input bit
  input wire B, // 1 input bit
  input wire carry_in, // carry in bit
  output wire sum_bit,
  output wire carry_out
);

assign sum_bit = A^B^carry_in;
assign carry_out = A&B | B&carry_in | A&carry_in; // if any two are turned on

endmodule