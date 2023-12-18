module pc (
  input clk,
  input rst,
  input pcsel,
  input takebranch,
  input [31:0] alu_result,
  input StallPc,
  input [31:0] Pc_update,
  output reg [31:0] IF_Instr,
  output reg [31:0] IF_Pc,
  output reg [31:0] IF_Pc4
);

reg [31:0] pc;
reg [31:0] next_pc;
reg [31:0] pc_plus_4;
wire [31:0] iout;

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
    // TODO: edge case where branch instr executes but data hazard detected.
    if (StallPc) begin
        next_pc <= Pc_update;  // Update PC with the stalled value imported from id
    end else if (pcsel && takebranch) begin
        next_pc = alu_result;
    end else begin
        next_pc = pc_plus_4; // Default increment by 4
    end
end

// assign pc_out = pc; // Output current PC value
// assign pc_out_4 = pc_plus_4; // Output PC + 4 for write-back to register

imem imem(
    .addr(pc),
    .data(iout) // Connect your instruction memory data
);

always @(posedge clk or posedge rst)
    if (rst) begin
        IF_Instr <= 0;
        IF_Pc <= 0;
        IF_Pc4 <= 0;
    end else begin
        IF_Instr <= iout;
        IF_Pc <= pc;
        IF_Pc4 <= pc_plus_4;
    end
endmodule