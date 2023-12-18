// `timescale 1ns / 1ps

module riscv_tb;

    // Inputs
    reg clk;
    reg rst;

    localparam NUM_STAGES = 1;
    localparam CLOCK_PERIOD = 20;
    localparam INSTR_DURATION = NUM_STAGES * CLOCK_PERIOD;

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
        uut.regfile.registers[1] = 32'b11111111111111111111111111110001;
        uut.regfile.registers[2] = 32'b00000000000000000000000000000011;
        rst = 0;  // Release reset
        #(INSTR_DURATION);
        assert(uut.regfile.wrdata == 32'hFFFFFFF4) else $error("ADD Test Failed: Expected WRDATA = %h, Actual WRDATA = %h", 32'hFFFFFFF4, uut.regfile.wrdata);
        #(INSTR_DURATION);
        assert(uut.regfile.wrdata == 32'hFFFFFFEE) else $error("SUB Test Failed: Expected WRDATA = %h, Actual WRDATA = %h", 32'hFFFFFFEE, uut.regfile.wrdata);
        #(INSTR_DURATION);
        assert(uut.regfile.wrdata == 32'h1) else $error("AND Test Failed: Expected WRDATA = %h, Actual WRDATA = %h", 32'h1, uut.regfile.wrdata);
        #(INSTR_DURATION);
        assert(uut.regfile.wrdata == 32'hFFFFFFF3) else $error("OR Test Failed: Expected WRDATA = %h, Actual WRDATA = %h", 32'hFFFFFFF3, uut.regfile.wrdata);
        #(INSTR_DURATION);
        assert(uut.regfile.wrdata == 32'hFFFFFFF2) else $error("XOR Test Failed: Expected WRDATA = %h, Actual WRDATA = %h", 32'hFFFFFFF2, uut.regfile.wrdata);
        #(INSTR_DURATION);
        assert(uut.regfile.wrdata == 32'hFFFFFF88) else $error("SLL Test Failed: Expected WRDATA = %h, Actual WRDATA = %h", 32'hFFFFFF88, uut.regfile.wrdata);
        #(INSTR_DURATION);
        assert(uut.regfile.wrdata == 32'h1FFFFFFE) else $error("SRL Test Failed: Expected WRDATA = %h, Actual WRDATA = %h", 32'h1FFFFFFE, uut.regfile.wrdata);
        #(INSTR_DURATION);
        assert(uut.regfile.wrdata == 32'hFFFFFFF4) else $error("SRA Test Failed: Expected WRDATA = %h, Actual WRDATA = %h", 32'hFFFFFFF4, uut.regfile.wrdata);
        #(INSTR_DURATION);
        assert(uut.regfile.wrdata == 32'hFFFFFFD3) else $error("MUL Test Failed: Expected WRDATA = %h, Actual WRDATA = %h", 32'hFFFFFFD3, uut.regfile.wrdata);
        #(INSTR_DURATION);
        assert(uut.regfile.wrdata == 32'h55555550) else $error("DIV Test Failed: Expected WRDATA = %h, Actual WRDATA = %h", 32'h55555550, uut.regfile.wrdata);
        // Imm Tests
        rst = 1;
        #(INSTR_DURATION);
        $readmemb("./mem/imem_i.txt", uut.pc.imem.mem);
        rst = 0;
        #(INSTR_DURATION);
        assert(uut.regfile.wrdata == 32'hFFFFFFF7) else $error("ADDI Test Failed: Expected WRDATA = %h, Actual WRDATA = %h", 32'hFFFFFFF7, uut.regfile.wrdata);
        #(INSTR_DURATION);
        assert(uut.regfile.wrdata == 32'hFFFFFF10) else $error("SLLI Test Failed: Expected WRDATA = %h, Actual WRDATA = %h", 32'hFFFFFF10, uut.regfile.wrdata);
        #(INSTR_DURATION);
        assert(uut.regfile.wrdata == 32'h1) else $error("SLTI Test Failed: Expected WRDATA = %h, Actual WRDATA = %h", 32'h1, uut.regfile.wrdata);
        #(INSTR_DURATION);
        assert(uut.regfile.wrdata == 32'hFFFFFFF7) else $error("xori Test Failed: Expected WRDATA = %h, Actual WRDATA = %h", 32'hFFFFFFF7, uut.regfile.wrdata);
        #(INSTR_DURATION);
        assert(uut.regfile.wrdata == 32'h0FFFFFFF) else $error("srli Test Failed: Expected WRDATA = %h, Actual WRDATA = %h", 32'h0FFFFFFF, uut.regfile.wrdata);
        #(INSTR_DURATION);
        assert(uut.regfile.wrdata == 32'hFFFFFFFF) else $error("srai Test Failed: Expected WRDATA = %h, Actual WRDATA = %h", 32'hFFFFFFFF, uut.regfile.wrdata);
        #(INSTR_DURATION);
        assert(uut.regfile.wrdata == 32'hFFFFFFF7) else $error("ori Test Failed: Expected WRDATA = %h, Actual WRDATA = %h", 32'hFFFFFFF7, uut.regfile.wrdata);
        #(INSTR_DURATION);
        assert(uut.regfile.wrdata == 32'h0) else $error("andi Test Failed: Expected WRDATA = %h, Actual WRDATA = %h", 32'h0, uut.regfile.wrdata);
        // #200;
        // ST Tests
        rst = 1;
        #(INSTR_DURATION);
        uut.regfile.registers[1] = 32'b00000000000000000000000000000100; // offset of 4 bytes
        uut.regfile.registers[2] = 32'b00000000000000000000000000000001; // 1 should be shown in register after load
        $readmemb("./mem/imem_st.txt", uut.pc.imem.mem);
        // $readmemb("./mem/dmem_ld.txt", uut.dmem.dram.mem);
        rst = 0;
        #(2*INSTR_DURATION);
        assert(uut.dmem.dram.mem[1] == 32'h1) else $error("ST Test Failed: Expected MEM = %h, Actual MEM = %h", 32'h1, uut.dmem.dram.mem[1]);
        assert(uut.regfile.wrdata == 32'h1) else $error("LD Test Failed: Expected WRDATA = %h, Actual WRDATA = %h", 32'h1, uut.regfile.wrdata);

        ///////////// BR Tests \\\\\\\\\\\\\\
        // Test BEQ
        rst = 1;
        #(INSTR_DURATION);
        rst = 0;
        $readmemb("./mem/br/imem_beq.txt", uut.pc.imem.mem);
        uut.regfile.registers[1] = 32'b00000000000000000000000000001101;
        uut.regfile.registers[2] = 32'b00000000000000000000000000001101;
        #(2*INSTR_DURATION);
        assert(uut.pc.pc == 32'hC) else $error("BEQ Test Failed: Expected PC = %h, Actual PC = %h", 32'hC, uut.pc.pc);
        // Test BNE
        rst = 1;
        #(INSTR_DURATION);
        rst = 0;
        $readmemb("./mem/br/imem_bne.txt", uut.pc.imem.mem);
        uut.regfile.registers[1] = 32'b00000000000000000000000000000001;
        uut.regfile.registers[2] = 32'b00000000000000000000000000001101;
        #(2*INSTR_DURATION);
        assert(uut.pc.pc == 32'hC) else $error("BNE Test Failed: Expected PC = %h, Actual PC = %h", 32'hC, uut.pc.pc);
        // Test BLT
        rst = 1;
        #(INSTR_DURATION);
        rst = 0;
        $readmemb("./mem/br/imem_blt.txt", uut.pc.imem.mem);
        uut.regfile.registers[1] = 32'd3;   // Smaller value
        uut.regfile.registers[2] = 32'd10;  // Larger value
        #(2*INSTR_DURATION);
        assert(uut.pc.pc == 32'hC) else $error("BLT Test Failed: Expected PC = %h, Actual PC = %h", 32'hC, uut.pc.pc);
        // Test BGE
        rst = 1;
        #(INSTR_DURATION);
        rst = 0;
        $readmemb("./mem/br/imem_bge.txt", uut.pc.imem.mem);
        uut.regfile.registers[1] = 32'd10;  // Larger value
        uut.regfile.registers[2] = 32'd3;   // Smaller value
        #(2*INSTR_DURATION);
        assert(uut.pc.pc == 32'hC) else $error("BGE Test Failed: Expected PC = %h, Actual PC = %h", 32'hC, uut.pc.pc);
        // Test BLTU
        rst = 1;
        #(INSTR_DURATION);
        rst = 0;
        $readmemb("./mem/br/imem_bltu.txt", uut.pc.imem.mem);
        uut.regfile.registers[1] = 32'd3;   // Smaller value
        uut.regfile.registers[2] = 32'd10;  // Larger value
        #(2*INSTR_DURATION);
        assert(uut.pc.pc == 32'hC) else $error("BTLU Test Failed: Expected PC = %h, Actual PC = %h", 32'hC, uut.pc.pc);
        // Test BGEU
        rst = 1;
        #(INSTR_DURATION);
        rst = 0;
        $readmemb("./mem/br/imem_bgeu.txt", uut.pc.imem.mem);
        uut.regfile.registers[1] = 32'd10;  // Larger value
        uut.regfile.registers[2] = 32'd3;   // Smaller value
        #(2*INSTR_DURATION);
        assert(uut.pc.pc == 32'hC) else $error("BGEU Test Failed: Expected PC = %h, Actual PC = %h", 32'hC, uut.pc.pc);
        #(2*INSTR_DURATION);

        // LUI Tests
        rst = 1;
        #(INSTR_DURATION);
        rst = 0;
        uut.pc.imem.mem[1] = 32'b00000000000000000001000110110111; // LUI Instruction
        #(INSTR_DURATION);
        assert(uut.regfile.wrdata == 32'h1000) else $error("LUI Test Failed: Expected PC = %h, Actual PC = %h", 32'h1000, uut.regfile.wrdata);
        #(2*INSTR_DURATION);

        // Test JAL
        rst = 1;
        #(INSTR_DURATION);
        rst = 0;
        uut.pc.imem.mem[1] = 32'b00000000010000000000000111101111; // JAL Instruction
        //                                ^ 2ndbit 10 << 2 = 1000 so we add 8 to PC to jump to 0xC
        #(INSTR_DURATION);
        // Should contain the PC+4
        assert(uut.regfile.wrdata == 32'h8) else $error("JAL Test Failed: Expected RD = %h, Actual RD = %h", 32'h8, uut.regfile.wrdata);
        #(INSTR_DURATION);
        assert(uut.pc.pc == 32'hC) else $error("JAL Test Failed: Expected PC = %h, Actual PC = %h", 32'hC, uut.pc.pc);
        #(2*INSTR_DURATION);

        // Test JALR
        rst = 1;
        #(INSTR_DURATION);
        rst = 0;
        uut.regfile.registers[1] = 32'b00000000000000000000000000000001;
        uut.pc.imem.mem[1] = 32'b00000000000100001000000111100111; // JALR Instruction
        //                                  ^ 1st imm bit
        #(INSTR_DURATION);
        // Should contain the PC+4
        assert(uut.regfile.wrdata == 32'h8) else $error("JALR Test Failed: Expected RD = %h, Actual RD = %h", 32'h8, uut.regfile.wrdata);
        #(INSTR_DURATION);
        // Result: reg1 + imm = 1 + 1 = 2
        assert(uut.pc.pc == 32'h2) else $error("JALR Test Failed: Expected PC = %h, Actual PC = %h", 32'h2, uut.pc.pc);
        #(2*INSTR_DURATION);

        // TODO:
        // auipc rd, offset	U	0x17			R[rd] ← PC + {offset, 12b0}
        // csrw rd, csr, rs1	I	0x73	0x1		CSR[csr] ← R[rs1]
        // csrwi rd, csr, uimm	0x5		CSR[csr] ← {uimm}

        // Complete the simulation
        $finish;
    end

endmodule
