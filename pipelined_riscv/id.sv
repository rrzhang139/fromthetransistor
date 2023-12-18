module id(
    input clk,
    input rst,
    input [31:0] IF_Instr, // Instruction data
    input [31:0] IF_Pc, // Program counter from IF stage
    input [31:0] IF_Pc4, // Program counter + 4 from IF stage
    input [31:0] WB_RegWData, // Data to write back to register
    input [4:0] WB_RegRd, // Destination register for write-back
    input WB_RegWrite, // Register write enable for write-back
    input IDEX_MemRead,  // Data hazard inputs for LD
    input EXMEM_MemRead,
    input MEMWB_MemRead,
    input [4:0] IDEX_Regd,
    input [4:0] EXMEM_Regd,
    input [4:0] MEMWB_Regd,
    input IDEX_MemWrite,  // Data hazard inputs for ST
    input EXMEM_MemWrite,
    input MEMWB_MemWrite,
    input [31:0] IDEX_MemAddr,
    input [31:0] EXMEM_MemAddr,
    input [31:0] MEMWB_MemAddr,
    input NopIFInstr,

    output reg [31:0] ID_Pc4, // Program counter + 4
    output reg [31:0] ID_Wdata, // Data to write to memory
    output reg [31:0] ID_Rdata1, // Register data 1
    output reg [31:0] ID_Rdata2, // Register data 2
    output reg [31:0] ID_BranchResult, // ALU output of adding two values for pc jump 
    output reg [4:0] ID_RegRd, // Register address dest
    output reg [3:0] ID_AluOp, // The ALU operation type (ADD = 0, ...)
    output reg ID_RegWrite, // Write to register file access
    output reg ID_MemRead, // Read from data memory enabled
    output reg ID_MemWrite, // Write permission data memory
    output reg [1:0] ID_Wbsel, // Source of data written back to register (0 = ALU, 1 = MEM, 2 = Imm)
    output reg ID_Pcsel, // Selector for PC source (pc+4, jmp, illegal instr, interrupt)
    output reg ID_TakeBranch, // Take branch signal
    output reg [31:0] ID_Imm, // Immediate value
    output reg StallPc,
    output reg [31:0] Pc_update,
    output reg [31:0] Stalled_Instr
    // output reg [1:0] ID_Memsz, // Size of data to read/write from/to data memory (0 = byte, 1 = half, 2 = word)
);

wire [31:0] Imm, rdata1, rdata1_out, rdata2, rdata2_out;
wire [4:0] reg1, reg2, regd;
wire [3:0] aluop;
wire [2:0] inst_format, branch_instr;
wire inst_undef, wreg, rmem, wmem, bsel, asel, pcsel, takebranch, BrEq, BrLt, DataHazardFlush;
wire [1:0] memsz, wbsel;
reg [31:0] Instr;

// hazardDetection module
hazardDetection hazard_detection_unit (
    .isNOP(NopIFInstr), // If NOP, we ignore calculating whether its data hazard
    .ID_MemRead(IDEX_MemRead),   // Input from the ID/EX pipeline register
    .EX_MemRead(EXMEM_MemRead),  // Input from the EX/MEM pipeline register
    .MEM_MemRead(MEMWB_MemRead), // Input from the MEM/WB pipeline register
    .ID_Regd(IDEX_Regd),         // Destination register in ID/EX pipeline register
    .EX_Regd(EXMEM_Regd),        // Destination register in EX/MEM pipeline register
    .MEM_Regd(MEMWB_Regd),       // Destination register in MEM/WB pipeline register
    .Rega(reg1),  // Source register A (from instruction)
    .Regb(reg2),  // Source register B (from instruction)
    .ID_MemWrite(IDEX_MemWrite),
    .EX_MemWrite(EXMEM_MemWrite),
    .MEM_MemWrite(MEMWB_MemWrite),
    .ID_MemAddr(IDEX_MemAddr),
    .EX_MemAddr(EXMEM_MemAddr),
    .MEM_MemAddr(MEMWB_MemAddr),
    .Mem_Read(rmem), // Indicate if its a LD
    .Mem_Addr(rdata1 + Imm), // LD memory address

    .DataHazardFlush(DataHazardFlush) // Output to control logic for flushing
);


// Control Unit
ctl ctl (
    .clk(clk),
    .rst(rst),
    .idata(IF_Instr),
    .reg1(reg1),
    .reg2(reg2),
    .regd(regd),
    .aluop(aluop),
    .inst_format(inst_format),
    .inst_undef(inst_undef),
    .wreg(wreg),
    .rmem(rmem),
    .wmem(wmem),
    .wbsel(wbsel),
    .pcsel(pcsel),
    .asel(asel),
    .bsel(bsel),
    .memsz(memsz),
    .branch_instr(branch_instr)
);

// Immediate Generator
ImmGen ImmGen (
    .InstFormat(inst_format),
    .Inst(IF_Instr),
    .Imm(Imm)
);

// Register File
regfile regfile (
    .clk(clk),
    .wreg(WB_RegWrite),
    .waddr(WB_RegRd),
    .raddr1(reg1),
    .raddr2(reg2),
    .wrdata(WB_RegWData),
    .rdata1(rdata1),
    .rdata2(rdata2)
);

// ALU A Operand Selector
assign rdata1_out = asel ? IF_Pc : rdata1;

// ALU B Operand Selector
assign rdata2_out = (branch_instr==BR_JALR) ? Imm :
                     bsel ? {Imm, 1'b0} : rdata2;

assign brun = branch_instr == BR_BLTU || branch_instr == BR_BGEU;

// Branch Comparator
branchcmp branchcmp (
    .rs1(rdata1),
    .rs2(rdata2),
    .BrUn(brun),
    .BrEq(BrEq),
    .BrLt(BrLt)
);

// Pipeline Logic for ID
// Procedural block for synchronized assignment of registers in 'id' module
always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset all output registers to their initial values
        ID_Pc4 <= 0;
        ID_Rdata1 <= 0;
        ID_Rdata2 <= 0;
        ID_BranchResult <= 0;
        ID_Wdata <= 0; // For ST
        ID_RegRd <= 0;
        ID_AluOp <= 4'b0;
        ID_RegWrite <= 1'b0;
        ID_MemRead <= 1'b0;
        ID_MemWrite <= 1'b0;
        ID_Wbsel <= 2'b0;
        ID_Pcsel <= 1'b0;
        ID_TakeBranch <= 1'b0;
        ID_Imm <= 0;
        StallPc <= 1'b0;
        Pc_update <= 0;
        // ID_Memsz <= 2'b0;
    end else begin
      if (NopIFInstr) begin
        // Create a nop
        createNOP(); // Function to create a NOP
      end else begin
        ID_RegWrite <= wreg;
        ID_MemRead <= rmem;
        ID_MemWrite <= wmem;
        ID_Wbsel <= wbsel;
        ID_Pcsel <=  pcsel;
      end
      if (DataHazardFlush) begin
        createNOP();
        Pc_update <= IF_Pc;
        StallPc <= 1'b1;
        Stalled_Instr <= IF_Instr; // Foward into IF register
      end else begin
        Pc_update <= 0;
        StallPc <= 1'b0;
        Stalled_Instr <= 32'b0;
      end
      ID_Pc4 <= IF_Pc4;
      ID_Rdata1 <= rdata1_out;
      ID_Rdata2 <= rdata2_out;
      ID_BranchResult <= rdata1_out + rdata2_out;
      ID_Wdata <= rdata2; // For ST
      ID_RegRd <= regd;
      ID_AluOp <= aluop;
      ID_TakeBranch <= (BrEq && branch_instr == BR_BEQ) || (!BrEq && branch_instr == BR_BNE) || (BrLt && branch_instr == BR_BLT)
          || (!BrLt && branch_instr == BR_BGE) || (!BrLt && branch_instr == BR_BGEU) || (BrLt && branch_instr == BR_BLTU) 
          || (branch_instr == BR_JAL) || (branch_instr == BR_JALR);
      ID_Imm <= Imm;
      // ID_Memsz <= memsz;
    end
end

// Function to create a NOP
task createNOP();
    ID_MemRead <= 1'b0;
    ID_MemWrite <= 1'b0;
    ID_RegWrite <= 1'b0;
    ID_Wbsel <= 1'b0;
    ID_Pcsel <= 1'b0;
endtask

endmodule