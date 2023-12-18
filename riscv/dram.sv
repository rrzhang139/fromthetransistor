module dram(
    input           clk     ,
    input rst,
    input [31:0]    addr    ,
    input [31:0]    wdata   ,
    input           wmem   ,
    input           rmem   , // TODO: when pipelining
    input [1:0] memsz, // TODO: when pipelinging memory size
    output [31:0]   rdata   
    );
    reg [31:0] mem[0:1023];
    always @(posedge clk or posedge rst)
        if (rst) 
          for (integer i = 0; i < 1024; i = i + 1) begin
            mem[i] <= 32'b0;
          end
        else if (wmem)        
          mem[addr[31:2]] <= wdata;
    assign rdata = mem[addr[31:2]];
endmodule