module wb(
    input clk,
    input rst,
    input [1:0] MEM_WBsel, // Write-back selector
    input [31:0] MEM_Alu_Result, // Result from ALU
    input [31:0] MEM_Rmemdata, // Data read from memory
    input [31:0] MEM_Imm, // Immediate value
    input [31:0] MEM_Pc4, // PC + 4 from IF stage
    input [4:0] MEM_RegD, // Destination register
    input MEM_WReg, // Register write enable

    output reg [31:0] WB_RegWData, // Data to write back to register
    output reg [4:0] WB_RegRd, // Destination register for write-back
    output reg WB_RegWrite // Register write enable for write-back
);

// Write-back logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        WB_RegWData <= 0;
        WB_RegRd <= 0;
        WB_RegWrite <= 0;
    end else begin
        // Select the data to be written back based on WBsel
        WB_RegWData <= (MEM_WBsel == Wb_Pc4) ? MEM_Pc4 :
                      (MEM_WBsel == Wb_Imm) ? MEM_Imm : 
                      (MEM_WBsel == Wb_Mem) ? MEM_Rmemdata : 
                      MEM_Alu_Result;
        WB_RegRd <= MEM_RegD; // Destination register for write-back
        WB_RegWrite <= MEM_WReg; // Enable write-back if necessary
    end
end

endmodule
