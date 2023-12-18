`timescale 1ns / 1ps

module immgen_tb;

    reg [2:0] InstFormat;
    reg [31:0] Inst;
    wire [31:0] Imm;

    // Instantiate the ImmGen module
    ImmGen uut (
        .InstFormat(InstFormat),
        .Inst(Inst),
        .Imm(Imm)
    );

    initial begin
        $dumpfile("out/immgen_tb.vcd");
        $dumpvars(0, immgen_tb);

        // Test I-Type Instruction
        InstFormat = InstFormat_I;
        Inst = 32'b00000000000100001000000010010011; // addi x1, x1, 1
        #10;
        assert (Imm == 32'd1) else $error("I-Type Test Failed: Expected Imm = 1, Got Imm = %d", Imm);

        // Test S-Type Instruction
        InstFormat = InstFormat_S;
        Inst = 32'b00000000000100001000000010100011; // sw x1, 1(x1)
        #10;
        assert (Imm == 32'd1) else $error("S-Type Test Failed: Expected Imm = 1, Got Imm = %d", Imm);

        // Test SB-Type Instruction
        InstFormat = InstFormat_SB;
        Inst = 32'b00000000000100001000001100001111; // beq x1, x1, 1
        #10;
        // Expecting a sign-extended offset for branch instructions
        assert (Imm == 32'h00000006) else $error("SB-Type Test Failed: Expected Imm = %h, Got Imm = %h", 32'h00000006, Imm);

        // Test U-Type Instruction
        InstFormat = InstFormat_U;
        Inst = 32'b00000000000000000001000010110111; // lui x1, 1
        #10;
        assert (Imm == 32'h00001000) else $error("U-Type Test Failed: Expected Imm = %h, Got Imm = %h", 32'h00000100, Imm);

        // Test UJ-Type Instruction
        InstFormat = InstFormat_UJ;
        Inst = 32'b00000000000100001000001101101111; // jal x1, 1
        #10;
        // Expecting a sign-extended offset for jump instructions
        assert (Imm == 32'h00040008) else $error("UJ-Type Test Failed: Expected Imm = %h, Got Imm = %h", 32'h00040008, Imm);

        // $display("All tests completed successfully.");
        $finish;
    end
endmodule
