//instruction format type
localparam [2:0] InstFormat_R  = 3'b000;  // Register-Register
localparam [2:0] InstFormat_I  = 3'b001;  // Register-Immediate
localparam [2:0] InstFormat_S  = 3'b010;  // Store
localparam [2:0] InstFormat_SB = 3'b011;  // Branch
localparam [2:0] InstFormat_U  = 3'b100;  // ...
localparam [2:0] InstFormat_UJ = 3'b101;

localparam AluOp_ADD  = 'h0; //alu addition
localparam AluOp_SUB  = 'h1; //
localparam AluOp_AND  = 'h2;
localparam AluOp_OR   = 'h3;
localparam AluOp_XOR  = 'h4;
localparam AluOp_SLL  = 'h5;
localparam AluOp_SRL  = 'h6;
localparam AluOp_SRA  = 'h7;
localparam AluOp_MUL  = 'h8;
localparam AluOp_DIV  = 'h9;
localparam AluOp_SLTI = 'ha;

localparam BR_BEQ = 'h0;
localparam BR_BNE = 'h1;
localparam BR_BLT = 'h2;
localparam BR_BGE = 'h3;
localparam BR_BLTU = 'h4;
localparam BR_BGEU = 'h5;
localparam BR_JAL = 'h6;
localparam BR_JALR = 'h7;

localparam Wb_Reg = 'h0;
localparam Wb_Mem = 'h1;
localparam Wb_Imm = 'h2;
localparam Wb_Pc4 = 'h3;

localparam NOP = 'b00000000000000000000000000110011; // r0 + r0 = r0

// localparam MemSize

//localparam Wb_mux_RegToReg = 0;
//localparam Wb_mux_MemToReg = 1;
//localparam Wb_mux_Pc4ToReg = 2;