module imem(
	input [31:0] addr,
	output reg [31:0] data
);

// initial begin 
// 	$readmemb("imem.txt", mem);
// end

	reg [31:0] mem[0:1023];
	assign data = mem[addr[31:2]];

endmodule