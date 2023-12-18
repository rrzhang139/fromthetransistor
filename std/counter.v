module counter (
    input clk,
    input rst, // active-high reset
    output [7:0] count
);

reg [7:0] count_int; // Internal counter register

always @(posedge clk or posedge rst) {
    if (rst)
        count_int <= 8'b00000000; // Reset counter to zero
    else
        count_int <= count_int + 1; // Increment counter
}

assign count = count_int;

endmodule
