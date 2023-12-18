module adder32 (
  input wire [31:0] A, // Input A
  input wire [31:0] B, // Input B
  input wire ALUFN,
  output wire [31:0] sum, // Output register
  output wire Z,
  output wire V,
  output wire N
);

wire [31:0] XB;
assign XB = B ^ (ALUFN ? 32'hFFFFFFFF : 32'h00000000);

wire [31:0] carry;

generate 
  genvar i;
  for (i=0; i < 32; i = i + 1) begin

    full_adder fa (
        .A(A[i]),
        .B(XB[i]),
        .carry_in(i == 0 ? ALUFN : carry[i-1]),
        .sum_bit(sum[i]),
        .carry_out(carry[i])
    );
  end
endgenerate

assign N = sum[31];
assign Z = sum == 0;

// Two scenarios: A[31] == B[31] and sum[31] != A[31]
//                A[31] != B[31] and sum[31] == A[31]
wire v1;
wire v2;
assign v1 = A[31]&XB[31]&~sum[31];
assign v2 = ~A[31]&~XB[31]&sum[31];
assign V = v1 | v2;

endmodule