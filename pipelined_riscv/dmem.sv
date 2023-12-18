module dmem(
    input clk,
    input rst,
    input [31:0] EX_Pc4,        // PC+4 from IF stage
    input [31:0] EX_Alu_Result, // Address from ALU
    input [31:0] EX_Wdata,     // Write data
    input [4:0] EX_RegD,        // Register destination
    input EX_WReg,              // Register write enable
    input EX_Wmem,              // Write enable
    input EX_Rmem,              // Read enable
    input [1:0] EX_WBsel,       // Write-back selector
    input [31:0] EX_Imm,               // Immediate value
    // input [1:0] EX_Memsz,     // Memory size (if needed)

    output reg [31:0] MEM_Rmemdata, // Read data
    output reg [31:0] MEM_Pc4,      // PC+4 from IF stage
    output reg [4:0] MEM_RegD,      // Register destination
    output reg [1:0] MEM_WBsel,     // Write-back selector
    output reg MEM_WReg,            // Register write enable for WB stage
    output reg [31:0] MEM_Imm,      // Immediate value
    output reg MEM_Rmem,
    output reg MEM_Wmem,
    output reg [31:0] MEM_Alu_Result // ALU result for WB stage
);

// Internal data memory instantiation
wire [31:0] MemRData;
dram dram(
    .addr(EX_Alu_Result),
    .wdata(EX_Wdata),
    .wmem(EX_Wmem),
    .rmem(EX_Rmem),
    .rdata(MemRData)
    // .memsz(EX_Memsz) // Uncomment if memory size is used
);

// Pipeline logic for MEM stage
always @(posedge clk or posedge rst) begin
    if (rst) begin
        MEM_Rmemdata <= 0;
        MEM_Pc4 <= 0;
        MEM_RegD <= 0;
        MEM_WBsel <= 0;
        MEM_WReg <= 0;
        MEM_Imm <= 0;
        MEM_Alu_Result <= 0;
        MEM_Wmem <= 0;
        MEM_Rmem <= 0;
    end else begin
        MEM_Rmemdata <= MemRData; // Data read from memory
        MEM_Pc4 <= EX_Pc4;
        MEM_RegD <= EX_RegD;
        MEM_WBsel <= EX_WBsel;
        MEM_WReg <= EX_WReg;
        MEM_Imm <= EX_Imm;
        MEM_Alu_Result <= EX_Alu_Result;
        MEM_Wmem <= EX_Wmem;
        MEM_Rmem <= EX_Rmem;
    end
end

endmodule
