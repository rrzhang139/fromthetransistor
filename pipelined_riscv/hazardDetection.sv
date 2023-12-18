module hazardDetection (
  input isNOP,
  // Data hazard: LD instr has not updated regd when another instr uses regd
  input ID_MemRead,
  input EX_MemRead,
  input MEM_MemRead,
  input [4:0] ID_Regd,
  input [4:0] EX_Regd,
  input [4:0] MEM_Regd,
  input [4:0] Rega,
  input [4:0] Regb,
  // Data hazard: ST instr has not updated its memory address when a LD uses the address
  input ID_MemWrite,
  input EX_MemWrite,
  input MEM_MemWrite,
  input [31:0] ID_MemAddr,
  input [31:0] EX_MemAddr,
  input [31:0] MEM_MemAddr,
  input Mem_Read,
  input [31:0] Mem_Addr,


  output reg DataHazardFlush //handling Reg read hazard
);

// wire OpAfterLD=0;
// OpAfterLD
assign DataHazardFlush = (ID_MemRead && (Rega == ID_Regd || Regb == ID_Regd)) 
              || (EX_MemRead && (Rega == EX_Regd || Regb == EX_Regd))
              || (MEM_MemRead && (Rega == MEM_Regd || Regb == MEM_Regd));
              // LDAfterST
              // || Mem_Read && (ID_MemWrite && (Mem_Addr == ID_MemAddr)) 
              // || (EX_MemWrite && (Mem_Addr == EX_MemAddr))
              // || (MEM_MemWrite && (Mem_Addr == MEM_MemAddr));

// same memory address made: Mem_Read is on AND Mem_Write is on AND mem_addr LD == mem_addr of ST in ID/EX/MEM
// assign LDAfterST = Mem_Read && (ID_MemWrite && (Mem_Addr == ID_MemAddr)) 
//               || (EX_MemWrite && (Mem_Addr == EX_MemAddr))
//               || (MEM_MemWrite && (Mem_Addr == MEM_MemAddr));

// assign DataHazardFlush = !isNOP && (OpAfterLD);

endmodule