module ctl(
  input clk,
  input rst,
  input [31:0] idata, // instruction data

  output [4:0] reg1, // register address src
  output [4:0] reg2, // register address src
  output [4:0] regd, // register address dest
  output reg [3:0] aluop, // the aluop type (ADD =0, ..)
  output reg [2:0] inst_format, // instruction format type (R, U, B, I)
  output reg inst_undef, // signals instruction is undefined
  output reg wreg, // write to register file access
  output reg rmem, // read from data memory enabled
  output reg wmem, // write permission data memory
  output reg [1:0] wbsel, // source of data written back to register (0 =ALU, 1 =MEM, 2=Imm)
  output reg pcsel, // selector for pc source (pc+4, jmp, illegal instr, interrupt)
  output reg asel, // selector for asel in regfile (auipc instruction) (0=reg, 1=pc)
  output reg bsel, // alu b input port selector (0 =reg, 1 =imm)
  output reg [1:0] memsz, // size of data to read/write from/to data memory (0 =byte, 1 =half, 2 =word)
  output reg [2:0] branch_instr // branch instruction type (0 = beq , 1 = bne, 2 = blt, 3 = bge, 4 = bltu, 5 = bgeu)
);

`include "riscv_def.sv"

wire [6:0] OpCode  = idata[6: 0];
assign 		regd     = idata[11: 7];
wire [2:0] Funct3  = idata[14:12];
assign 		reg1    = idata[19:15];
assign		 reg2   = idata[24:20];
wire [6:0] Funct7  = idata[31:25];

// Make into combinational logic

always @(*) 
  if (rst) begin
    aluop = 0;
    inst_format  = 0;
    inst_undef =0;
    wreg  = 0;
    rmem  = 0;
    wmem  = 0;
    wbsel  = Wb_Reg;
    pcsel  = 0;
    bsel  = 0;
    memsz = 0;
    branch_instr = 0;
    asel = 0;
  end else begin 
        aluop = 0;
        inst_format  = 0;
        inst_undef =0;
        wreg  = 0;
        rmem  = 0;
        wmem  = 0;
        wbsel  = Wb_Reg;
        pcsel  = 0;
        bsel  = 0;
        memsz = 0;
        branch_instr = 0;
        asel = 0;
        case(OpCode)
        // 00110011
        'h33: begin //OpCode
            wreg = 1;
            inst_format  = InstFormat_R;
            case(Funct3)
    //add rd, rs1, rs2 	    R 	    0x33 	0x0 	0x00 	R[rd] ← R[rs1] + R[rs2]
    //mul rd, rs1, rs2 	                    0x0 	0x01 	R[rd] ← (R[rs1] * R[rs2])[31:0]
    //sub rd, rs1, rs2 	                    0x0 	0x20 	R[rd] ← R[rs1] - R[rs2]
            'h00:begin //Funct3    
                case(Funct7)
                'h00:begin
                    aluop = AluOp_ADD;
                end
                'h01:begin
                    aluop = AluOp_MUL;
                end
                'h20:begin
                    aluop = AluOp_SUB;
                end
                default: begin
                	inst_undef =1;
                end
                endcase
            end
    //sll rd, rs1, rs2 	                    0x1 	0x00 	R[rd] ← R[rs1]    R[rs2
    //mulh rd, rs1, rs2 	                0x1 	0x01 	R[rd] ← (R[rs1] * R[rs2])[63:32]
            'h01:begin //Funct3
                case(Funct7)
                'h00:begin
                    aluop = AluOp_SLL;
                end
                'h01:begin
                    aluop = AluOp_MUL;
                end
                default:begin
                	inst_undef =1;
                end
                endcase
            end
    //slt rd, rs1, rs2 	                    0x2 	0x00 	R[rd] ← (R[rs1]   R[rs2]) ? 1 : 0 (signed)
            'h02:begin //Funct3
                case(Funct7)
                'h00:begin
                    aluop = AluOp_SUB;
                end
                default:begin
                	inst_undef =1;
                end
                endcase
            end
    //xor rd, rs1, rs2 	                    0x4 	0x00 	R[rd] ← R[rs1] ^ R[rs2]
    //div rd, rs1, rs2 	                    0x4 	0x01 	R[rd] ← R[rs1] / R[rs2]
            'h04:begin //Funct3
                case(Funct7)
                'h00: begin
                    aluop = AluOp_XOR;
                end
                'h01: begin
                    aluop = AluOp_DIV;
                end
                default:begin
                	inst_undef =1;
                end
                endcase
            end
    //srl rd, rs1, rs2 	                    0x5 	0x00 	R[rd] ← R[rs1] >> R[rs2]
            'h05:begin //Funct3
                case(Funct7) 
                'h00:begin
                    aluop = AluOp_SRL;
                end
                default:begin
                	inst_undef =1;
                end
                endcase
            end
    //or rd, rs1, rs2 	                    0x6 	0x00 	R[rd] ← R[rs1] | R[rs2]
    //rem rd, rs1, rs2 	                    0x6 	0x01 	R[rd] ← (R[rs1] % R[rs2]
            'h06:begin //Funct3
                case(Funct7)
                'h00:begin
                    aluop = AluOp_OR;
                end
                'h01:begin
                    aluop = AluOp_DIV;
                end
                default:begin
                	inst_undef =1;
                end
                endcase
            end
    //and rd, rs1, rs2 	                    0x7 	0x00 	R[rd] ← R[rs1] & R[rs2]
            'h07:begin //Funct3
                case(Funct7) 
                'h00: begin
                    aluop = AluOp_AND;
                end
                default:begin
                	inst_undef =1;
                end 
                endcase
             end
             default:begin
             	inst_undef =1;
             end
        endcase
    	end 
        'h03:begin //OpCode
    //--------------------------------------------------------------------------------
    //lb rd, offset(rs1) 	I 	    0x03 	0x0 	        R[rd] ← SignExt(Mem(R[rs1] + offset, byte))
    //lh rd, offset(rs1) 	                0x1 		    R[rd] ← SignExt(Mem(R[rs1] + offset, half))
    //lw rd, offset(rs1) 	                0x2 		    R[rd] ← Mem(R[rs1] + offset, word)
            aluop = AluOp_ADD;
            inst_format  = InstFormat_I;
            wreg = 1;
            rmem  = 1;
            bsel = 1; // we are using immediate
            wbsel  = Wb_Mem;
            case(Funct3)
            'h00: begin
                memsz = 0; // lb
            end
            'h01:begin
                memsz = 1; // lh
            end
            'h02:begin
                memsz = 2; // lw
            end
            default:begin
            	inst_undef =1;
            end
            endcase
        end
        'h13:begin //OpCode
    //addi rd, rs1, imm 	        0x13 	0x0 	        R[rd] ← R[rs1] + imm
    //slli rd, rs1, imm 	                0x1 	0x00 	R[rd] ← R[rs1]    imm
    //slti rd, rs1, imm 	                0x2 		    R[rd] ← (R[rs1] <  imm) ? 1 : 0
    //xori rd, rs1, imm 	                0x4 		    R[rd] ← R[rs1] ^ imm
    //srli rd, rs1, imm 	                0x5 	0x00 	R[rd] ← R[rs1] >> imm
    //srai rd, rs1, imm	                    0x5	    0x20	R[rd] ← R[rs1] >>> imm
    //ori rd, rs1, imm 	                    0x6 		    R[rd] ← R[rs1] | imm
    //andi rd, rs1, imm 	                0x7 		    R[rd] ← R[rs1] & imm
            inst_format  = InstFormat_I;
            wreg = 1;
            bsel  = 1; // we use imm value as the B operand of alu
            case(Funct3)
            'h0:begin //Funct3
                aluop = AluOp_ADD;
            end
            'h1:begin //Funct3
                case(Funct7)
                'h00:begin
                    aluop = AluOp_SLL;
                end
                default:begin
                	inst_undef =1;
                end
                endcase
            end
            'h2: begin //Funct3
                    aluop = AluOp_SLTI;
            end
            'h4: begin //Funct3
                    aluop = AluOp_XOR;
            end
            'h5: begin //Funct3
                case(Funct7)
                'h00:begin
                    aluop = AluOp_SRL;
                end
                'h20:begin
                    aluop = AluOp_SRA;
                end
                default:begin
                	inst_undef =1;
                end
                endcase
            end
            'h6: begin //Funct3
                    aluop = AluOp_OR;
            end
            'h7: begin //Funct3
                    aluop = AluOp_AND;
            end
            default:begin
            	inst_undef =1;
            end
            endcase //Funct3
        end
        'h23:begin //OpCode
    //--------------------------------------------------------------------------------
    //sw rs2, offset(imm) 	S 	     0x23 	0x2 	        Mem(R[rs1] + offset) ← R[rs2]
            wmem = 1;
            bsel = 1; // We use imm
            inst_format  = InstFormat_S;
            aluop = AluOp_ADD;
            wreg = 0;
            // case(Funct3)
            // 'h2:begin
            // end
            // default:begin
            // 	inst_undef =1;
            // end
            // endcase //Funct3
        end
        'h63:begin //OpCode
    //--------------------------------------------------------------------------------
    //beq rs1, rs2, offset 	SB 	     0x63 	0x0 	        if(R[rs1]  = = R[rs2])
    //                                                      PC ← PC + {offset, 1b'0}
    //blt rs1, rs2, offset 	                0x4 		    if(R[rs1] less than R[rs2] (signed))
    //                                                      PC ← PC + {offset, 1b'0}
    //bltu rs1, rs2, offset 	            0x6 		    if(R[rs1] less than R[rs2] (unsigned))
    //                                                      PC ← PC + {offset, 1b'0}
            inst_format  = InstFormat_SB;
            pcsel = 1; // Jump
            asel = 1; // We use pc to add offset
            bsel = 1; // We use imm
            case(Funct3)
            'h0:begin //Funct3
                branch_instr = BR_BEQ;
            end
            'h1:begin //Funct3
                branch_instr = BR_BNE;
            end
            'h4:begin //Funct3
                branch_instr = BR_BLT;
            end
            'h5:begin //Funct3
                branch_instr = BR_BGE;
            end
            'h6:begin //Funct3
                branch_instr = BR_BLTU;
            end
            'h7:begin //Funct3
                branch_instr = BR_BGEU;
            end
            default:begin
                inst_undef =1;
            end
            endcase //Funct3
        end
    //--------------------------------------------------------------------------------
    // auipc rd, offset	U	0x17			R[rd] ← PC + {offset, 12b0}
        'h17:begin
            inst_format = InstFormat_U;
            wreg = 1;
            asel = 1;
            bsel = 1; // We use imm
        end
    //--------------------------------------------------------------------------------
    //lui rd, offset 	    U 	     0x37                   R[rd] ← {offset, 12b'0}
        'h37:begin //OpCode
            inst_format  = InstFormat_U;
            wreg = 1;
            wbsel = Wb_Imm;
        end
    //--------------------------------------------------------------------------------
    //jal rd, imm 	        UJ 	     0x6f 			        R[rd] ← PC + 4
    //                                                      PC ← PC + {imm, 1b'0}
        'h6f:begin //OpCode
            wreg = 1;
            pcsel = 1;
            asel = 1; // We use pc to add offset
            bsel = 1; // We use imm
            inst_format  = InstFormat_UJ;
            branch_instr = BR_JAL;
            wbsel  = Wb_Pc4;
        end
    //--------------------------------------------------------------------------------
    //jalr rd,rs, imm 	    I 	     0x67 	0x0 	        R[rd] ← PC + 4
    //                                                      PC ← R[rs] + {imm} 
    //--------------------------------------------------------------------------------
        'h67:begin //OpCode
            inst_format  = InstFormat_I;
            branch_instr = BR_JALR;
            wreg = 1;
            bsel = 1; // We use imm
            pcsel = 1;
            wbsel = Wb_Pc4;
        end
        default: begin
            inst_undef =1;
        end
        endcase //OpCode
    end	
	
endmodule