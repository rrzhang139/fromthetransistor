module ex (
    input clk,
    input rst,
    input [3:0] ID_AluOp,
    input [31:0] ID_Rdata1,
    input [31:0] ID_Rdata2,
    input [31:0] ID_Wdata,
    input [31:0] ID_Imm,
    input [4:0] ID_RegRd,
    input ID_Wmem,
    input ID_Rmem,
    input [1:0] ID_Wbsel,
    input ID_WReg,
    input [31:0] ID_Pc4,

    output reg [31:0] EX_Alu_Result,
    output reg [31:0] EX_Pc4,
    output reg [4:0] EX_RegD,
    output reg [31:0] EX_Wdata,
    output reg EX_Wmem,
    output reg EX_Rmem,
    output reg [1:0] EX_WBsel,
    output reg EX_WReg,
    output reg [31:0] EX_Imm
);

// Internal signal for ALU result
reg [31:0] alu_result;

// ALU instantiation
alu alu (
    .aluop(ID_AluOp), 
    .alu_a(ID_Rdata1),    
    .alu_b(ID_Rdata2), // Assuming ID_Rdata2 is the correct input, adjust if necessary
    .alu_result(alu_result)
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        EX_Alu_Result <= 0;
        EX_Pc4 <= 0;
        EX_RegD <= 0;
        EX_Wdata <= 0;
        EX_Wmem <= 0;
        EX_Rmem <= 0;
        EX_WBsel <= 0;
        EX_WReg <= 0;
        EX_Imm <= 0;
    end else begin
        EX_Alu_Result <= alu_result;
        EX_Pc4 <= ID_Pc4;
        EX_RegD <= ID_RegRd;
        EX_Wdata <= ID_Wdata;
        EX_Wmem <= ID_Wmem;
        EX_Rmem <= ID_Rmem;
        EX_WBsel <= ID_Wbsel;
        EX_WReg <= ID_WReg;
        EX_Imm <= ID_Imm;
    end
end

endmodule
