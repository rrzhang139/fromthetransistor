module dram(
    input [31:0]    addr    ,
    input [31:0]    wdata   ,
    input           wmem   ,
    input           rmem   ,
    // input [1:0] memsz, // TODO: when pipelinging memory size
    output reg [31:0]   rdata   
    );
    reg [31:0] mem[0:1023];

    initial begin 
      for (integer i = 0; i < 1024; i = i + 1) begin
        mem[i] <= 32'b0;
      end
    end

    always @(*) begin
        if (wmem)        
          mem[addr[31:2]] <= wdata;
        if (rmem) begin
          // if (memsz == byte) 
          //   rdata <= {{24{mem[addr[31:0]][7]}}, mem[addr[31:0]][7:0]};
          rdata <= mem[addr[31:2]];
        end
    end
    
endmodule