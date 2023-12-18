//data memory top block
module dmem(
    input clk,
    input rst,
    input [31:0] alu_result , //the result of ALU - gives address to write or read
    input [31:0] wdata, // write data
    input wmem, // write data enable
    input rmem, // read data enable
    input [1:0] memsz, // memory size
    output [31:0] rdata // read data
    );

   //data memory
    wire [31:0] MemRData;
     dram dram(
        .clk  (clk),
        .rst(rst),
        .addr (alu_result),
        .wdata(wdata),
        .wmem(wmem),
        .rmem(rmem),
        .rdata(rdata),
        .memsz(memsz)
    );

    // always @(posedge clk or posedge rst)
    //     if (rst) begin
          
    //     end else begin
            
    //     end
endmodule