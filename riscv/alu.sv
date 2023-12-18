module alu(
    input       [3:0]  aluop        ,
    input       [31:0] alu_a        ,    
    input       [31:0] alu_b        ,    
    output reg  [31:0] alu_result
);
`include "riscv_def.sv"

    always @(*) begin
        case(aluop)
        AluOp_ADD  : begin
            alu_result = alu_a + alu_b;
        end
        AluOp_SUB  : begin
            alu_result = alu_a - alu_b;
        end
        AluOp_AND  : begin
            alu_result = alu_a & alu_b;
        end
        AluOp_OR   : begin
            alu_result = alu_a | alu_b;
        end
        AluOp_XOR  : begin
            alu_result = alu_a ^ alu_b;
        end
        AluOp_SLL  : begin
            alu_result = alu_a << alu_b;
        end
        AluOp_SRL  : begin
            alu_result = alu_a >> alu_b;
        end
        AluOp_SRA  : begin
            alu_result = $signed(alu_a) >>> alu_b;
        end
        AluOp_MUL  : begin
            alu_result = alu_a * alu_b;
        end
        AluOp_DIV  : begin
            alu_result = alu_a / alu_b;
        end
        AluOp_SLTI: begin
            alu_result = ($signed(alu_a) < $signed(alu_b)) ? 32'd1 : 32'd0;
        end
        default:begin
        end
        endcase
    end

endmodule