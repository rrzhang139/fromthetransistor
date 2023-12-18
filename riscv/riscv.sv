module riscv (
    input clk,
    input rst
);

wire [31:0] idata, Imm, rdata1, rdata1_out, rdata2, rdata2_out, wrdata, alu_result, rmemdata, pc_out, pc_out_4;
wire [4:0] reg1, reg2, regd;
wire [3:0] aluop;
wire [2:0] inst_format, branch_instr;
wire inst_undef, wreg, rmem, wmem, bsel, asel, pcsel, takebranch;
wire [1:0] memsz, wbsel;


assign takebranch = (BrEq && branch_instr == BR_BEQ) || (!BrEq && branch_instr == BR_BNE) || (BrLt && branch_instr == BR_BLT)
           || (!BrLt && branch_instr == BR_BGE) || (!BrLt && branch_instr == BR_BGEU) || (BrLt && branch_instr == BR_BLTU) 
           || (branch_instr == BR_JAL) || (branch_instr == BR_JALR);

// Program Counter
pc pc (
    .clk(clk), 
    .rst(rst), 
    .pcsel(pcsel),
    .takebranch(takebranch),
    .alu_result(alu_result),
    .iout(idata),
    .pc_out(pc_out),
    .pc_out_4(pc_out_4)
);

// Control Unit
ctl ctl (
    .clk(clk),
    .rst(rst),
    .idata(idata),
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
    .Inst(idata),
    .Imm(Imm)
);

// Register File
regfile regfile (
    .clk(clk),
    .wreg(wreg),
    .waddr(regd),
    .raddr1(reg1),
    .raddr2(reg2),
    .wrdata(wrdata),
    .rdata1(rdata1),
    .rdata2(rdata2)
);

// ALU A Operand Selector
assign rdata1_out = asel ? pc_out : rdata1;

// ALU B Operand Selector
assign rdata2_out = (branch_instr==BR_JALR) ? Imm :
                     bsel ? {Imm, 1'b0} : rdata2;

// Write-back Selector
assign wrdata = (wbsel == Wb_Pc4) ? pc_out_4 :
                (wbsel == Wb_Imm) ? Imm : 
                (wbsel == Wb_Mem) ? rmemdata : 
                alu_result;

// ALU
alu alu (
    .aluop(aluop), 
    .alu_a(rdata1_out),    
    .alu_b(rdata2_out),    
    .alu_result(alu_result)
);

assign brun = branch_instr == BR_BLTU || branch_instr == BR_BGEU;

// Branch Comparator
branchcmp branchcmp (
    .rs1(rdata1),
    .rs2(rdata2),
    .BrUn(brun),
    .BrEq(BrEq),
    .BrLt(BrLt)
);

// Data Memory
dmem dmem (
    .clk(clk),
    .rst(rst),
    .alu_result(alu_result),
    .wdata(rdata2),
    .wmem(wmem),
    .rdata(rmemdata),
    .memsz(memsz)
);

endmodule
