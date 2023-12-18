module blinking_led (
    input wire clk,      // Clock
    output reg led       // LED output
);

reg [31:0] cnt = 0; // 32-bit counter

always @(posedge clk) begin
    cnt <= cnt + 1; // Increment the counter on each clock tick
end

always @(cnt) begin
    if(cnt < 16'd50) begin
        led <= 1'b0;
    end else begin
        led <= 1'b1;
    end
end

endmodule

