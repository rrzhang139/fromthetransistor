module mux2 (
    input wire sel,    // Select signal
    input wire [1:0] in,  // 2-bit input data
    output wire out     // Output data
);

    assign out = (sel) ? in[1] : in[0];

endmodule
