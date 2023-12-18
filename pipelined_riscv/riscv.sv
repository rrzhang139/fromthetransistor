module riscv (
    input clk,
    input rst
);

wire [31:0] Imm, rdata1, rdata1_out, rdata2, rdata2_out, wrdata, alu_result, rmemdata;
wire [4:0] reg1, reg2, regd;
wire [3:0] aluop;
wire [2:0] inst_format, branch_instr;
wire inst_undef, wreg, rmem, wmem, bsel, asel, pcsel, takebranch;
wire [1:0] memsz, wbsel;

/////////////////////// IF Pipeline Registers \\\\\\\\\\\\\\\\\\\\\\\\\
reg [31:0] IF_Instr, IF_Pc, IF_Pc4;
// From the EX stage output writing back to pc
wire [31:0] ID_BranchResult, ID_PcUpdate;
wire ID_Pcsel, ID_Takebranch;

// Program Counter
pc pc (
    .clk(clk), 
    .rst(rst),
    .pcsel(ID_Pcsel),
    .takebranch(ID_Takebranch),
    .alu_result(ID_BranchResult),
    .Pc_update(ID_PcUpdate),
    .StallPc(StallPc),

    .IF_Instr(IF_Instr),
    .IF_Pc(IF_Pc),
    .IF_Pc4(IF_Pc4)
);

/////////////////////// ID Pipeline Registers \\\\\\\\\\\\\\\\\\\\\\\\\

// Define the registers/wires to connect to the 'id' module
// From the IF stage output
reg [31:0] ID_Pc4;
// From the ID stage output
reg [31:0] ID_AluResult, ID_Imm, Stalled_Instr;
reg [4:0] ID_RegRd;
reg [31:0] ID_Rdata1, ID_Rdata2, ID_Wdata;
reg ID_MemRead, ID_MemWrite, ID_MemToReg, ID_RegWrite, StallPc;
reg [3:0] ID_AluOp;
reg [2:0] ID_Branch_Instr;
reg [1:0] ID_Wbsel, ID_Memsz;
// From the WB stage output writing back to register
wire [4:0]  WB_RegRd; 
wire        WB_RegWrite;
wire [31:0] WB_RegWData;

reg [31:0] Instr;
reg [31:0] Pc;
always @(*) begin
    if (StallPc) begin
        Instr <= Stalled_Instr;
        Pc <= ID_PcUpdate;
    end else begin
        Instr <= IF_Instr;
        Pc <= IF_Pc;
    end
end

// Instantiate the 'id' module
id id (
    .clk(clk),
    .rst(rst),
    .IF_Instr(Instr),
    .IF_Pc(Pc),
    .IF_Pc4(IF_Pc4),
    .NopIFInstr((ID_Takebranch && ID_Pcsel) || StallPc), // StallPc means we found data hazard
    .IDEX_MemRead(ID_MemRead),
    .EXMEM_MemRead(EX_Rmem),
    .MEMWB_MemRead(MEM_Rmem),
    .IDEX_Regd(ID_RegRd),
    .EXMEM_Regd(EX_RegD),
    .MEMWB_Regd(MEM_RegD),
    .IDEX_MemWrite(ID_MemWrite),
    .EXMEM_MemWrite(EX_Wmem),
    .MEMWB_MemWrite(MEM_Wmem),
    .IDEX_MemAddr(ID_Rdata1 + ID_Rdata2),
    .EXMEM_MemAddr(EX_Alu_Result), // Alu result to calculate ST address
    .MEMWB_MemAddr(MEM_Alu_Result),
    // Write back data from WB stage
    .WB_RegWData(WB_RegWData),
    .WB_RegRd(WB_RegRd),
    .WB_RegWrite(WB_RegWrite),


    .ID_Rdata1(ID_Rdata1),
    .ID_Rdata2(ID_Rdata2),
    .ID_BranchResult(ID_BranchResult),
    .ID_Wdata(ID_Wdata),
    .ID_RegRd(ID_RegRd),
    .ID_AluOp(ID_AluOp),
    .ID_RegWrite(ID_RegWrite),
    .ID_MemRead(ID_MemRead),
    .ID_MemWrite(ID_MemWrite),
    .ID_Wbsel(ID_Wbsel),
    .ID_Pcsel(ID_Pcsel),
    .ID_TakeBranch(ID_Takebranch),
    .ID_Imm(ID_Imm),
    .ID_Pc4(ID_Pc4), // From IF
    .Pc_update(ID_PcUpdate),
    .StallPc(StallPc),
    .Stalled_Instr(Stalled_Instr)
    // .ID_Memsz(ID_Memsz),
);

// What does ALU/MEM/WB need to know?
// ALU: aluop, rdata1, rdata2
// MEM: rdata2, wmem, rmem
// WB:  wreg, regd, wrdata, wbsel, pc_4, pc, imm

/////////////////////// EX Pipeline Registers \\\\\\\\\\\\\\\\\\\\\\\\\

// Registers passed from other stages
// From the IF stage output
reg [31:0] EX_Pc4; 
// From the ID stage output
reg [4:0] EX_RegD;
reg [1:0] EX_WBsel;
reg [31:0] EX_Wdata, EX_Imm;
reg EX_Wmem, EX_Rmem, EX_WReg;
// EX-specific registers
reg [31:0] EX_Alu_Result;

ex ex (
    .clk(clk),
    .rst(rst),
    .ID_Pc4(ID_Pc4), // From IF
    .ID_AluOp(ID_AluOp), // From ID
    .ID_Rdata1(ID_Rdata1),
    .ID_Rdata2(ID_Rdata2),
    .ID_Wdata(ID_Wdata),
    .ID_RegRd(ID_RegRd),
    .ID_Wmem(ID_MemWrite),
    .ID_Rmem(ID_MemRead),
    .ID_Wbsel(ID_Wbsel),
    .ID_WReg(ID_RegWrite),
    .ID_Imm(ID_Imm),

    .EX_Alu_Result(EX_Alu_Result),
    .EX_Pc4(EX_Pc4), // From IF
    .EX_RegD(EX_RegD), // From ID
    .EX_Wdata(EX_Wdata),
    .EX_Wmem(EX_Wmem),
    .EX_Rmem(EX_Rmem),
    .EX_WBsel(EX_WBsel),
    .EX_WReg(EX_WReg),
    .EX_Imm(EX_Imm)
);

// What does MEM and WB need to know from ALU?
// MEM: alu_result
// WB:  alu_result, wbsel, pc_4, pc, imm, rmemdata

/////////////////////// MEM Pipeline Registers \\\\\\\\\\\\\\\\\\\\\\\\\

// Registers passed from other stages
// From the IF stage output
reg [31:0] MEM_Pc4; 
// From the ID stage output
reg [4:0] MEM_RegD;
reg [1:0] MEM_WBsel;
reg MEM_Wmem, MEM_Rmem, MEM_WReg;
reg [31:0] MEM_Imm;
// From the EX stage output
reg [31:0] MEM_Alu_Result;
// MEM-specific registers
reg [31:0] MEM_Rmemdata;

// Data Memory
dmem dmem (
    .clk(clk),
    .rst(rst),
    .EX_Pc4(EX_Pc4), // From IF
    .EX_RegD(EX_RegD), // From ID
    .EX_Wdata(EX_Wdata),
    .EX_Wmem(EX_Wmem),
    .EX_Rmem(EX_Rmem),
    .EX_WBsel(EX_WBsel),
    .EX_WReg(EX_WReg),
    .EX_Imm(EX_Imm),
    .EX_Alu_Result(EX_Alu_Result),

    .MEM_Rmemdata(MEM_Rmemdata),
    .MEM_Pc4(MEM_Pc4), // From IF
    .MEM_RegD(MEM_RegD), // From ID
    .MEM_Rmem(MEM_Rmem),
    .MEM_Wmem(MEM_Wmem),
    .MEM_WReg(MEM_WReg),
    .MEM_WBsel(MEM_WBsel),
    .MEM_Imm(MEM_Imm),
    .MEM_Alu_Result(MEM_Alu_Result) // From EX
);

/////////////////////// WB Pipeline Registers \\\\\\\\\\\\\\\\\\\\\\\\\

// Write-back
wb wb (
    .clk(clk),
    .rst(rst),
    .MEM_Pc4(MEM_Pc4), // From IF
    .MEM_RegD(MEM_RegD), // From ID
    .MEM_WReg(MEM_WReg),
    .MEM_WBsel(MEM_WBsel),
    .MEM_Imm(MEM_Imm),
    .MEM_Alu_Result(MEM_Alu_Result), // From EX
    .MEM_Rmemdata(MEM_Rmemdata), // From MEM

    .WB_RegWData(WB_RegWData),
    .WB_RegRd(WB_RegRd), // From ID
    .WB_RegWrite(WB_RegWrite)
);


endmodule


// NEXT: ask chatgpt simpler way to calculate the address for ST earlier since it is calculated in EX stage