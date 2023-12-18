
module regfile (
  input clk,
  input wreg, // write to register
  input [4:0] waddr, // write register address
  input [4:0] raddr1, // read address 1
  input [4:0] raddr2, // read address 2
  input [31:0] wrdata, // write register data
  output [31:0] rdata1, // read data 1
  output [31:0] rdata2 // read data 2
);

// initialize the 31 registers 
reg [31:0] registers [0:31];

// Initialize specific registers with predefined values
initial begin
    for (integer i = 0; i < 32; i = i + 1) begin
        registers[i] = 32'b0;
    end
end

// take read address radder1
assign rdata1 = (raddr1 != 0) ? registers[raddr1] : 0;
assign rdata2 = (raddr2 != 0) ? registers[raddr2] : 0;

// write to register only on a clock edge
always @(posedge clk) begin
  if (wreg && waddr != 0) begin
    registers[waddr] = wrdata;
  end
end

endmodule