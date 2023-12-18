module ImmGen(
    input       [2:0]  InstFormat,
    input       [31:0] Inst , // from IfId
    output reg  [31:0] Imm      
);

   `include "riscv_def.sv" 
   // 31  25|24  20|19  15|14   12|11  7|6       0| 
   // funct7|  rs2 | rs1  |funct3 |rd   | opcode  |
   //  7    |   5  | 5    |  3    | 5   |  7      |
	
    always @(*)begin
        case(InstFormat)
        //InstFormat_R :;
        InstFormat_I: begin
            // Check if it is a shift operation (slli, srli, srai)
            if (Inst[14:12] == 3'b001 || Inst[14:12] == 3'b101) begin
                // For shift operations, use only the lower 5 bits of the immediate field
                Imm = {27'b0, Inst[24:20]};
            end else begin
                // For other I-type instructions
                Imm = {{20{Inst[31]}}, Inst[31:20]};
            end
        end
        InstFormat_S :Imm = {{20{Inst[31]}}, Inst[31:25], Inst[11:7]};
        InstFormat_SB:Imm = {{19{Inst[31]}}, Inst[31], Inst[7], Inst[30:25], Inst[11:8],1'b0};
        InstFormat_U :Imm = {Inst[31:12],12'h0};
        InstFormat_UJ: Imm = {{12{Inst[31]}}, Inst[19:12], Inst[20], Inst[30:21], 1'b0};
        default:begin
            Imm = 32'b0; // Default case to handle undefined instruction formats
        end
        endcase
    end 
endmodule