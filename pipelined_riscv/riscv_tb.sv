// `timescale 1ns / 1ps

module riscv_tb;

    // Inputs
    reg clk;
    reg rst;

    localparam NUM_STAGES = 5;
    localparam CLOCK_PERIOD = 20;
    // Add 1 because wrdata updates at clock edge
    localparam INSTR_DURATION = (NUM_STAGES + 1) * CLOCK_PERIOD;

    // Instantiate the RISC-V Processor
    riscv uut (
        .clk(clk), 
        .rst(rst)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk;  // Generate a clock with a period of 20 ns
    end

    // Test sequence
    initial begin
        $dumpfile("out/riscv.vcd");
        $dumpvars(0, riscv_tb);
        uut.pc.imem.mem[0] = 32'b00000000000000000000000000000000; // NOP
        // ALU Tests
        rst = 1;  // Apply reset
        #(INSTR_DURATION);      // Wait until right before the first posedge of the clock
        $readmemb("./mem/imem_alu.txt", uut.pc.imem.mem);
        uut.id.regfile.registers[1] = 32'b11111111111111111111111111110001;
        uut.id.regfile.registers[2] = 32'b00000000000000000000000000000011;
        rst = 0;  // Release reset
        #(INSTR_DURATION);
        // After the first instruction completes all 5 stages, subsequent cycles
        //  to get result are only 1 clock cycle
        assert(uut.id.regfile.registers[3] == 32'hFFFFFFF4) else $error("ADD Test Failed: Expected WRDATA = %h, Actual WRDATA = %h", 32'hFFFFFFF4, uut.id.regfile.registers[3]);
        #(CLOCK_PERIOD);
        assert(uut.id.regfile.registers[3] == 32'hFFFFFFEE) else $error("SUB Test Failed: Expected WRDATA = %h, Actual WRDATA = %h", 32'hFFFFFFEE, uut.id.regfile.registers[3]);
        #(CLOCK_PERIOD);
        assert(uut.id.regfile.registers[3] == 32'h1) else $error("AND Test Failed: Expected WRDATA = %h, Actual WRDATA = %h", 32'h1, uut.id.regfile.registers[3]);
        #(CLOCK_PERIOD);
        assert(uut.id.regfile.registers[3] == 32'hFFFFFFF3) else $error("OR Test Failed: Expected WRDATA = %h, Actual WRDATA = %h", 32'hFFFFFFF3, uut.id.regfile.registers[3]);
        #(CLOCK_PERIOD);
        assert(uut.id.regfile.registers[3] == 32'hFFFFFFF2) else $error("XOR Test Failed: Expected WRDATA = %h, Actual WRDATA = %h", 32'hFFFFFFF2, uut.id.regfile.registers[3]);
        #(CLOCK_PERIOD);
        assert(uut.id.regfile.registers[3] == 32'hFFFFFF88) else $error("SLL Test Failed: Expected WRDATA = %h, Actual WRDATA = %h", 32'hFFFFFF88, uut.id.regfile.registers[3]);
        #(CLOCK_PERIOD);
        assert(uut.id.regfile.registers[3] == 32'h1FFFFFFE) else $error("SRL Test Failed: Expected WRDATA = %h, Actual WRDATA = %h", 32'h1FFFFFFE, uut.id.regfile.registers[3]);
        #(CLOCK_PERIOD);
        assert(uut.id.regfile.registers[3] == 32'hFFFFFFF4) else $error("SRA Test Failed: Expected WRDATA = %h, Actual WRDATA = %h", 32'hFFFFFFF4, uut.id.regfile.registers[3]);
        #(CLOCK_PERIOD);
        assert(uut.id.regfile.registers[3] == 32'hFFFFFFD3) else $error("MUL Test Failed: Expected WRDATA = %h, Actual WRDATA = %h", 32'hFFFFFFD3, uut.id.regfile.registers[3]);
        #(CLOCK_PERIOD);
        assert(uut.id.regfile.registers[3] == 32'h55555550) else $error("DIV Test Failed: Expected WRDATA = %h, Actual WRDATA = %h", 32'h55555550, uut.id.regfile.registers[3]);
        // Imm Tests
        rst = 1;
        #(CLOCK_PERIOD);
        $readmemb("./mem/imem_i.txt", uut.pc.imem.mem);
        rst = 0;
        #(INSTR_DURATION);
        assert(uut.id.regfile.registers[3] == 32'hFFFFFFF7) else $error("ADDI Test Failed: Expected WRDATA = %h, Actual WRDATA = %h", 32'hFFFFFFF7, uut.id.regfile.registers[3]);
        #(CLOCK_PERIOD);
        assert(uut.id.regfile.registers[3] == 32'hFFFFFF10) else $error("SLLI Test Failed: Expected WRDATA = %h, Actual WRDATA = %h", 32'hFFFFFF10, uut.id.regfile.registers[3]);
        #(CLOCK_PERIOD);
        assert(uut.id.regfile.registers[3] == 32'h1) else $error("SLTI Test Failed: Expected WRDATA = %h, Actual WRDATA = %h", 32'h1, uut.id.regfile.registers[3]);
        #(CLOCK_PERIOD);
        assert(uut.id.regfile.registers[3] == 32'hFFFFFFF7) else $error("xori Test Failed: Expected WRDATA = %h, Actual WRDATA = %h", 32'hFFFFFFF7, uut.id.regfile.registers[3]);
        #(CLOCK_PERIOD);
        assert(uut.id.regfile.registers[3] == 32'h0FFFFFFF) else $error("srli Test Failed: Expected WRDATA = %h, Actual WRDATA = %h", 32'h0FFFFFFF, uut.id.regfile.registers[3]);
        #(CLOCK_PERIOD);
        assert(uut.id.regfile.registers[3] == 32'hFFFFFFFF) else $error("srai Test Failed: Expected WRDATA = %h, Actual WRDATA = %h", 32'hFFFFFFFF, uut.id.regfile.registers[3]);
        #(CLOCK_PERIOD);
        assert(uut.id.regfile.registers[3] == 32'hFFFFFFF7) else $error("ori Test Failed: Expected WRDATA = %h, Actual WRDATA = %h", 32'hFFFFFFF7, uut.id.regfile.registers[3]);
        #(CLOCK_PERIOD);
        assert(uut.id.regfile.registers[3] == 32'h0) else $error("andi Test Failed: Expected WRDATA = %h, Actual WRDATA = %h", 32'h0, uut.id.regfile.registers[3]);
        // #200;
        // ST Tests
        rst = 1;
        #(CLOCK_PERIOD);
        uut.id.regfile.registers[1] = 32'b00000000000000000000000000000100; // offset of 4 bytes
        uut.id.regfile.registers[2] = 32'b00000000000000000000000000000001; // 1 should be shown in register after load
        $readmemb("./mem/imem_st.txt", uut.pc.imem.mem);
        // $readmemb("./mem/dmem_ld.txt", uut.dmem.dram.mem);
        rst = 0;
        assert(uut.id.regfile.registers[3] == 32'h0) else $error("LD Test Failed: Expected Reg3 = %h, Actual Reg3 = %h", 32'h0, uut.id.regfile.registers[3]);
        #(INSTR_DURATION);
        #(2*CLOCK_PERIOD); // Add 40 because need to wait for WB 
        assert(uut.dmem.dram.mem[1] == 32'h1) else $error("ST Test Failed: Expected MEM = %h, Actual MEM = %h", 32'h1, uut.dmem.dram.mem[1]);
        assert(uut.id.regfile.registers[3] == 32'h1) else $error("LD Test Failed: Expected Reg3 = %h, Actual Reg3 = %h", 32'h1, uut.id.regfile.registers[3]);

        ///////////// BR Tests \\\\\\\\\\\\\\
        // Test BEQ
        rst = 1;
        #(CLOCK_PERIOD);
        rst = 0;
        $readmemb("./mem/br/imem_beq.txt", uut.pc.imem.mem);
        uut.id.regfile.registers[1] = 32'b00000000000000000000000000001101;
        uut.id.regfile.registers[2] = 32'b00000000000000000000000000001101;
        #(4*CLOCK_PERIOD); // update pc in the ex stage, AFTER we processed id stage using output 
        assert(uut.pc.pc == 32'h24) else $error("BEQ Test Failed: Expected PC = %h, Actual PC = %h", 32'h24, uut.pc.pc);
        // Test BNE
        rst = 1;
        #(CLOCK_PERIOD);
        rst = 0;
        $readmemb("./mem/br/imem_bne.txt", uut.pc.imem.mem);
        uut.id.regfile.registers[1] = 32'b00000000000000000000000000000001;
        uut.id.regfile.registers[2] = 32'b00000000000000000000000000001101;
        #(4*CLOCK_PERIOD); // update pc in the ex stage, AFTER we processed id stage using output  
        assert(uut.pc.pc == 32'h24) else $error("BNE Test Failed: Expected PC = %h, Actual PC = %h", 32'h24, uut.pc.pc);
        // Test BLT
        rst = 1;
        #(CLOCK_PERIOD);
        rst = 0;
        $readmemb("./mem/br/imem_blt.txt", uut.pc.imem.mem);
        uut.id.regfile.registers[1] = 32'd3;   // Smaller value
        uut.id.regfile.registers[2] = 32'd10;  // Larger value
        #(4*CLOCK_PERIOD); // update pc in the ex stage, AFTER we processed id stage using output 
        assert(uut.pc.pc == 32'h24) else $error("BLT Test Failed: Expected PC = %h, Actual PC = %h", 32'h24, uut.pc.pc);
        // Test BGE
        rst = 1;
        #(CLOCK_PERIOD);
        rst = 0;
        $readmemb("./mem/br/imem_bge.txt", uut.pc.imem.mem);
        uut.id.regfile.registers[1] = 32'd10;  // Larger value
        uut.id.regfile.registers[2] = 32'd3;   // Smaller value
        #(4*CLOCK_PERIOD); // update pc in the ex stage, AFTER we processed id stage using output 
        assert(uut.pc.pc == 32'h24) else $error("BGE Test Failed: Expected PC = %h, Actual PC = %h", 32'h24, uut.pc.pc);
        // Test BLTU
        rst = 1;
        #(CLOCK_PERIOD);
        rst = 0;
        $readmemb("./mem/br/imem_bltu.txt", uut.pc.imem.mem);
        uut.id.regfile.registers[1] = 32'd3;   // Smaller value
        uut.id.regfile.registers[2] = 32'd10;  // Larger value
        #(4*CLOCK_PERIOD); // update pc in the ex stage, AFTER we processed id stage using output 
        assert(uut.pc.pc == 32'h24) else $error("BTLU Test Failed: Expected PC = %h, Actual PC = %h", 32'h24, uut.pc.pc);
        // Test BGEU
        rst = 1;
        #(CLOCK_PERIOD);
        rst = 0;
        $readmemb("./mem/br/imem_bgeu.txt", uut.pc.imem.mem);
        uut.id.regfile.registers[1] = 32'd10;  // Larger value
        uut.id.regfile.registers[2] = 32'd3;   // Smaller value
        #(4*CLOCK_PERIOD); // update pc in the ex stage, AFTER we processed id stage using output 
        assert(uut.pc.pc == 32'h24) else $error("BGEU Test Failed: Expected PC = %h, Actual PC = %h", 32'h24, uut.pc.pc);

        // LUI Tests
        rst = 1;
        #(CLOCK_PERIOD);
        rst = 0;
        uut.pc.imem.mem[1] = 32'b00000000000000000001000110110111; // LUI Instruction
        #(INSTR_DURATION);
        assert(uut.id.regfile.registers[3] == 32'h1000) else $error("LUI Test Failed: Expected PC = %h, Actual PC = %h", 32'h1000, uut.id.regfile.registers[3]);

        // Test JAL
        rst = 1;
        #(CLOCK_PERIOD);
        rst = 0;
        uut.pc.imem.mem[1] = 32'b00000000010000000000000111101111; // JAL Instruction
        //                                ^ 2ndbit 10 << 2 = 1000 so we add 8 to PC to jump to 0xC
        #(4*CLOCK_PERIOD); // update pc in the ex stage, AFTER we processed id stage using output 
        assert(uut.pc.pc == 32'hC) else $error("JAL Test Failed: Expected PC = %h, Actual PC = %h", 32'hC, uut.pc.pc);
        #(2*CLOCK_PERIOD); // finish the rest of the stages of the instruction
        // Should contain the PC+4
        assert(uut.id.regfile.registers[3] == 32'h8) else $error("JAL Test Failed: Expected RD = %h, Actual RD = %h", 32'h8, uut.id.regfile.registers[3]);

        // Test JALR
        rst = 1;
        #(CLOCK_PERIOD);
        rst = 0;
        uut.id.regfile.registers[1] = 32'b00000000000000000000000000000001;
        uut.pc.imem.mem[1] = 32'b00000000000100001000000111100111; // JALR Instruction
        //                                  ^ 1st imm bit
        #(4*CLOCK_PERIOD); // update pc in the ex stage, AFTER we processed id stage using output 
        // Result: reg1 + imm = 1 + 1 = 2
        assert(uut.pc.pc == 32'h2) else $error("JALR Test Failed: Expected PC = %h, Actual PC = %h", 32'h2, uut.pc.pc);
        #(2*CLOCK_PERIOD); // finish the rest of the stages of the instruction
        // Should contain the PC+4
        assert(uut.id.regfile.registers[3] == 32'h8) else $error("JALR Test Failed: Expected RD = %h, Actual RD = %h", 32'h8, uut.id.regfile.registers[3]);

        ///////////// Data Hazard Tests \\\\\\\\\\\\\\
        // LD then ADD using the same register
        rst = 1;
        #(CLOCK_PERIOD);
        uut.dmem.dram.mem[1] = 32'b00000000000000000000000000001001; // Store a unique value in 4-byte offsetted data mem
        uut.id.regfile.registers[1] = 32'b00000000000000000000000000000100; // offset of 4 bytes
        uut.id.regfile.registers[2] = 32'b00000000000000000000000000000001; 
        uut.id.regfile.registers[3] = 32'b00000000000000000000000000000000;
        uut.pc.imem.mem[0] = 32'b00000000000000000000000000000000;
        uut.pc.imem.mem[1] = 32'b00000000000000001000000110000011; // LD Instruction
        // 000000000100_00001_000_00011_0000011  // (R[rd] ← Mem(R[rs1] + offset, word))
        uut.pc.imem.mem[2] = 32'b00000000001000011000000110110011; // ADD Instruction (uses reg 3)
        uut.pc.imem.mem[3] = 32'b00000000000000001000000110000011; // LD Instruction (uses reg 3)
        uut.pc.imem.mem[4] = 32'b00000000001100001000000001100011; // BR Instruction (uses reg 3)
        uut.pc.imem.mem[5] = 32'b00000000001000001000000000100011; // ST Instruction (uses addr 0x4)
        uut.pc.imem.mem[6] = 32'b00000000000000001000000110000011; // LD Instruction (uses addr 0x4)
        uut.pc.imem.mem[7] = 32'b01000000001000001000000010110011; // SUB Instruction (uses reg 3)
        rst = 0;
        // #(INSTR_DURATION);
        #(3*CLOCK_PERIOD); 
        // Here ID registers hold LD, IF registers hold ADD
        assert(uut.id.DataHazardFlush == 1'h1) else $error("Test Failed: Expected DataHazardFlush = %h, Actual DataHazardFlush = %h", 1'h1, uut.id.DataHazardFlush);
        assert(uut.ID_MemRead == 1'h1) else $error("Test Failed: Expected ID_MemRead = %h, Actual ID_MemRead = %h", 1'h1, uut.ID_MemRead);
        #(CLOCK_PERIOD); 
        // Here EX registers hold LD, IF registers hold NOP (ADD)
        // We repeat the ADD instruction again, 
        assert(uut.id.DataHazardFlush == 1'h1) else $error("Test Failed: Expected DataHazardFlush = %h, Actual DataHazardFlush = %h", 1'h1, uut.id.DataHazardFlush);
        assert(uut.id.Pc_update == 32'h8) else $error("Test Failed: Expected Pc = %h, Actual Pc = %h", 32'h8, uut.id.Pc_update);
        assert(uut.EX_Rmem == 1'h1) else $error("Test Failed: Expected EX_MemRead = %h, Actual MEM_MemRead = %h", 1'h1, uut.EX_Rmem);
        #(CLOCK_PERIOD); 
        // Here Mem registers hold LD, IF registers hold NOP (ADD), pc is now ADD again
        assert(uut.id.DataHazardFlush == 1'h1) else $error("Test Failed: Expected DataHazardFlush = %h, Actual DataHazardFlush = %h", 1'h1, uut.id.DataHazardFlush);
        assert(uut.pc.pc == 32'h8) else $error("Test Failed: Expected Pc = %h, Actual Pc = %h", 32'h8, uut.pc.pc);
        assert(uut.MEM_Rmem == 1'h1) else $error("Test Failed: Expected MEM_MemRead = %h, Actual MEM_MemRead = %h", 1'h1, uut.MEM_Rmem);
        #(CLOCK_PERIOD);
        // Here WB registers hold LD, IF registers hold NOP (ADD), pc is ADD again
        // Since reg 3 is now updated here, we can turn off the datahazardflush
        assert(uut.id.DataHazardFlush == 1'h0) else $error("Test Failed: Expected DataHazardFlush = %h, Actual DataHazardFlush = %h", 1'h0, uut.id.DataHazardFlush);
        assert(uut.pc.pc == 32'h8) else $error("Test Failed: Expected Pc = %h, Actual Pc = %h", 32'h8, uut.pc.pc);
        // we send the last flush and update the pc one more time, then next cycle we process it. 
        assert(uut.pc.Pc_update == 32'h8) else $error("Test Failed: Expected PcUpdate = %h, Actual PcUpdate = %h", 32'h8, uut.pc.Pc_update);
        assert(uut.id.regfile.registers[3] == 32'h9) else $error("Reg Test Failed: Expected RD = %h, Actual RD = %h", 32'h9, uut.id.regfile.registers[3]);
        #(CLOCK_PERIOD);
        // Instructions should resume. pc should now execute the ADD operation
        assert(uut.pc.Pc_update == 32'h0) else $error("Test Failed: Expected PcUpdate = %h, Actual PcUpdate = %h", 32'h0, uut.pc.Pc_update);
        assert(uut.pc.pc == 32'h8) else $error("Test Failed: Expected Pc = %h, Actual Pc = %h", 32'h8, uut.pc.pc);
        assert(uut.id.regfile.registers[3] == 32'h9) else $error("Reg Test Failed: Expected RD = %h, Actual RD = %h", 32'h9, uut.id.regfile.registers[3]);
        #(CLOCK_PERIOD);
        assert(uut.pc.pc == 32'hC) else $error("Test Failed: Expected Pc = %h, Actual Pc = %h", 32'hC, uut.pc.pc);

        // Test BR instruction after LD
        uut.id.regfile.registers[3] = 32'b00000000000000000000000000000000; // Reset the register 3
        #(2*CLOCK_PERIOD); 
        // Here ID registers hold LD, IF registers hold ADD
        assert(uut.id.DataHazardFlush == 1'h1) else $error("Test Failed: Expected DataHazardFlush = %h, Actual DataHazardFlush = %h", 1'h1, uut.id.DataHazardFlush);
        assert(uut.ID_MemRead == 1'h1) else $error("Test Failed: Expected ID_MemRead = %h, Actual ID_MemRead = %h", 1'h1, uut.ID_MemRead);
        #(CLOCK_PERIOD); 
        // Here EX registers hold LD, IF registers hold NOP (ADD)
        // We repeat the ADD instruction again, 
        assert(uut.id.DataHazardFlush == 1'h1) else $error("Test Failed: Expected DataHazardFlush = %h, Actual DataHazardFlush = %h", 1'h1, uut.id.DataHazardFlush);
        assert(uut.id.Pc_update == 32'h10) else $error("Test Failed: Expected Pc = %h, Actual Pc = %h", 32'h10, uut.id.Pc_update);
        assert(uut.EX_Rmem == 1'h1) else $error("Test Failed: Expected EX_MemRead = %h, Actual MEM_MemRead = %h", 1'h1, uut.EX_Rmem);
        #(CLOCK_PERIOD); 
        // Here Mem registers hold LD, IF registers hold NOP (ADD), pc is now ADD again
        assert(uut.id.DataHazardFlush == 1'h1) else $error("Test Failed: Expected DataHazardFlush = %h, Actual DataHazardFlush = %h", 1'h1, uut.id.DataHazardFlush);
        assert(uut.pc.pc == 32'h10) else $error("Test Failed: Expected Pc = %h, Actual Pc = %h", 32'h10, uut.pc.pc);
        assert(uut.MEM_Rmem == 1'h1) else $error("Test Failed: Expected MEM_MemRead = %h, Actual MEM_MemRead = %h", 1'h1, uut.MEM_Rmem);
        #(CLOCK_PERIOD);
        // Here WB registers hold LD, IF registers hold NOP (ADD), pc is ADD again
        // Since reg 3 is now updated here, we can turn off the datahazardflush
        assert(uut.id.DataHazardFlush == 1'h0) else $error("Test Failed: Expected DataHazardFlush = %h, Actual DataHazardFlush = %h", 1'h0, uut.id.DataHazardFlush);
        assert(uut.pc.pc == 32'h10) else $error("Test Failed: Expected Pc = %h, Actual Pc = %h", 32'h10, uut.pc.pc);
        // we send the last flush and update the pc one more time, then next cycle we process it. 
        assert(uut.pc.Pc_update == 32'h10) else $error("Test Failed: Expected PcUpdate = %h, Actual PcUpdate = %h", 32'h10, uut.pc.Pc_update);
        assert(uut.id.regfile.registers[3] == 32'h9) else $error("Reg Test Failed: Expected RD = %h, Actual RD = %h", 32'h9, uut.id.regfile.registers[3]);
        #(CLOCK_PERIOD);
        // Instructions should resume. pc should now execute the ADD operation
        assert(uut.pc.Pc_update == 32'h0) else $error("Test Failed: Expected PcUpdate = %h, Actual PcUpdate = %h", 32'h0, uut.pc.Pc_update);
        assert(uut.pc.pc == 32'h10) else $error("Test Failed: Expected Pc = %h, Actual Pc = %h", 32'h10, uut.pc.pc);
        assert(uut.id.regfile.registers[3] == 32'h9) else $error("Reg Test Failed: Expected RD = %h, Actual RD = %h", 32'h9, uut.id.regfile.registers[3]);
        #(CLOCK_PERIOD);
        assert(uut.pc.pc == 32'h14) else $error("Test Failed: Expected Pc = %h, Actual Pc = %h", 32'h14, uut.pc.pc);

        // // Test Control Hazard (Use NOP)
        // // First try a BEQ operation and branch successfully
        // rst = 1;
        // #(CLOCK_PERIOD);
        // rst = 0;
        // // insert BEQ then subseqent alu operations
        // $readmemb("./mem/br/imem_nop.txt", uut.pc.imem.mem);
        // uut.id.regfile.registers[1] = 32'b00000000000000000000000000001101;
        // uut.id.regfile.registers[2] = 32'b00000000000000000000000000001101;
        // #(3*CLOCK_PERIOD); 
        // // Here is when id stage has the NOP instruction
        // assert(uut.id.Instr == NOP) else $error("NOP Test Failed: Expected Instr = %h, Actual Instr = %h", NOP, uut.id.Instr);
        // assert(uut.id.ctl.reg1 == 32'h0) else $error("NOP Test Failed: Expected Reg = %h, Actual Reg = %h", 32'h0, uut.id.ctl.reg1);
        // assert(uut.id.ctl.reg2 == 32'h0) else $error("NOP Test Failed: Expected Reg = %h, Actual Reg = %h", 32'h0, uut.id.ctl.reg2);
        // assert(uut.id.ctl.regd == 32'h0) else $error("NOP Test Failed: Expected Reg = %h, Actual Reg = %h", 32'h0, uut.id.ctl.regd);
        // #(5*CLOCK_PERIOD);

        
        // TODO:
        // auipc rd, offset	U	0x17			R[rd] ← PC + {offset, 12b0}
        // csrw rd, csr, rs1	I	0x73	0x1		CSR[csr] ← R[rs1]
        // csrwi rd, csr, uimm	0x5		CSR[csr] ← {uimm}

        // Complete the simulation
        $finish;
    end

endmodule