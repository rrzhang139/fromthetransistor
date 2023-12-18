module branchcmp(
  input [31:0] rs1,
  input [31:0] rs2,
  input BrUn, // Flag to indicate unsigned comparison
  output reg BrEq,
  output reg BrLt
);

  always @(*) begin
    BrEq = (rs1 == rs2); // Equality check is the same for signed and unsigned
    if (BrUn) begin
      // Unsigned comparison
      BrLt = (rs1 < rs2);
    end else begin
      // Signed comparison
      BrLt = ($signed(rs1) < $signed(rs2));
    end
  end

endmodule
