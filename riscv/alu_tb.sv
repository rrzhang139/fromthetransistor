`timescale 1ns / 1ps

module alu_tb;

    reg [3:0] aluop;
    reg [31:0] alu_a, alu_b;
    wire [31:0] alu_result;

    // Instantiate the ALU module
    alu uut (
        .aluop(aluop), 
        .alu_a(alu_a), 
        .alu_b(alu_b), 
        .alu_result(alu_result)
    );

    initial begin
        $dumpfile("out/alu.vcd");
        $dumpvars(0, alu_tb);

        // Test Case: Addition
        aluop = AluOp_ADD;
        alu_a = 32'd15;
        alu_b = 32'd10;
        #10;
        assert (alu_result == 32'd25) else $error("ADD Test Failed: %d + %d != %d", alu_a, alu_b, alu_result);

        // Test Case: Subtraction
        aluop = AluOp_SUB;
        alu_a = 32'd20;
        alu_b = 32'd5;
        #10;
        assert (alu_result == 32'd15) else $error("SUB Test Failed: %d - %d != %d", alu_a, alu_b, alu_result);

        // Test Case: AND
        aluop = AluOp_AND;
        alu_a = 32'hAA;
        alu_b = 32'h55;
        #10;
        assert (alu_result == 32'h00) else $error("AND Test Failed: %b & %b != %b", alu_a, alu_b, alu_result);

        // Test Case: OR
        aluop = AluOp_OR;
        alu_a = 32'hA0;
        alu_b = 32'h0A;
        #10;
        assert (alu_result == 32'hAA) else $error("OR Test Failed: %b | %b != %b", alu_a, alu_b, alu_result);

        // Test Case: XOR
        aluop = AluOp_XOR;
        alu_a = 32'hFF;
        alu_b = 32'hAA;
        #10;
        assert (alu_result == 32'h55) else $error("XOR Test Failed: %b ^ %b != %b", alu_a, alu_b, alu_result);

        // Test Case: SLL (Shift Left Logical)
        aluop = AluOp_SLL;
        alu_a = 32'd1;
        alu_b = 32'd2;
        #10;
        assert (alu_result == 32'd4) else $error("SLL Test Failed: %b << %d != %b", alu_a, alu_b, alu_result);

        // Test Case: SRL (Shift Right Logical)
        aluop = AluOp_SRL;
        alu_a = 32'd4;
        alu_b = 32'd1;
        #10;
        assert (alu_result == 32'd2) else $error("SRL Test Failed: %b >> %d != %b", alu_a, alu_b, alu_result);

        // Test Case: SRA (Shift Right Arithmetic)
        aluop = AluOp_SRA;
        alu_a = 32'b11111111111111111111111111111110;
        alu_b = 32'd1;
        #10;
        assert (alu_result == 32'b11111111111111111111111111111111) else $error("SRA Test Failed: %b >>> %d != %b", alu_a, alu_b, alu_result);

        // Test Case: MUL (Multiplication)
        aluop = AluOp_MUL;
        alu_a = 32'd7;
        alu_b = 32'd6;
        #10;
        assert (alu_result == 32'd42) else $error("MUL Test Failed: %d * %d != %d", alu_a, alu_b, alu_result);

        // Test Case: DIV (Division)
        aluop = AluOp_DIV;
        alu_a = 32'd100;
        alu_b = 32'd5;
        #10;
        assert (alu_result == 32'd20) else $error("DIV Test Failed: %d / %d != %d", alu_a, alu_b, alu_result);

        // Test Case: SLTI (Set Less Than Immediate)
        aluop = AluOp_SLTI;
        alu_a = 32'd10;
        alu_b = 32'd20;
        #10;
        assert (alu_result == 32'd1) else $error("SLTI Test Failed: %d < %d != %d", alu_a, alu_b, alu_result);

        // Complete the simulation
        $finish;
    end
      
endmodule
