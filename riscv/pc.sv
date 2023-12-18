module pc (
  input clk,
  input rst,
  input pcsel,
  input takebranch,
  input [31:0] alu_result,
  output reg [31:0] iout,
  output reg [31:0] pc_out,
  output reg [31:0] pc_out_4
);

reg [31:0] pc;
reg [31:0] next_pc;
reg [31:0] pc_plus_4;

always @(posedge clk or posedge rst) begin 
    if (rst) begin 
        pc <= 0;
    end else begin
        pc <= next_pc; // Update PC with the next value
    end
end

// calculates next pc
always @(*) begin
    pc_plus_4 = pc + 4; // Calculate PC + 4
    if (pcsel && takebranch) begin
        next_pc = alu_result;
    end else begin
        next_pc = pc_plus_4; // Default increment by 4
    end
end

assign pc_out = pc; // Output current PC value
assign pc_out_4 = pc_plus_4; // Output PC + 4 for write-back to register

imem imem(
    .addr(pc),
    .data(iout) // Connect your instruction memory data
);

endmodule

// reg [31:0] pc;

// //PC add 4
// // wire 	[31:0] iPcAdd4;
// // assign iPcAdd4 = 

// // //next Pc calculation
// // reg 	[31:0] next_pc;
// // always @(*) begin
// //     next_pc = iPcAdd4;
// // end

// assign pc_out = pc;

// imem imem(
//   .addr(pc),
//   .data(iout)
// );

// always @(posedge clk or posedge rst) begin 
//     if (rst) begin 
//         pc <= 0;
//     end else if (pcsel) begin
//         if (branch_instr == 6) begin // jal
//             // pc <= pc + 4;
//             pc <= pc + {branch_offset, 1'b0}; // Append '0' to multiply offset by 2
//         end else if (branch_instr == 7) begin // jalr
//             // pc <= pc + 4;
//             pc <= rdata + branch_offset;
//         end else if ((BrEq && branch_instr == 0) || (!BrEq && branch_instr == 1) || (BrLt && branch_instr == 2)
//            || (BrLt && branch_instr == 4) || (!BrLt && branch_instr == 3) || (!BrLt && branch_instr == 5)) begin
//             pc <= pc + {branch_offset, 1'b0}; // Append '0' to multiply offset by 2
//         end
//     end else begin
//         pc <= pc + 4; // Increment PC by 4 to go to the next instruction
//     end
// end

// endmodule