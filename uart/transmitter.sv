module transmitter(
    input logic clk,
    input logic reset,
    input logic tx_start,
    input logic [7:0] data_in,
    output logic tx_line,
    output logic tx_busy
);

typedef enum {
    Idle, Start, Data, Stop, Cleanup
} states_t;

// 5 states so 3 bits needed
reg [2:0] state, next_state;
// 8 bits for counter
reg [2:0] Dctr;



// reset: is sequential signal, used to immediately halt and return to idle
// procedural block that executes every clock cycle
always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= Idle;
        // next_state <= Idle;
        Dctr <= 3'b000;
    end else begin
        // state <= next_state;
    end

    if (state == Start) begin
        if (clk) begin
            state = Data;
            tx_line = data_in[Dctr];
        end
        // else next_state = Start;
    end
    else if (state == Data) begin
        // tx_line = data_in[Dctr]; // serially transmitting data
        if (Dctr == 3'b111) begin
            state = Stop;
            tx_line = 1;
        end else begin
            state = Data;
            Dctr = Dctr + 1;
            tx_line = data_in[Dctr];
        end
    end
    else if (state == Stop) begin
        if (clk) state = Idle;
        // else next_state = Stop;
    end
end

// sensitivity list contains all the combinational logic inputs
always @(state, tx_start, Dctr) begin 
    case(state)
        Idle: begin
            tx_line = 1;
            tx_busy = 0;
            if (tx_start) begin
                state = Start;
                tx_line = 0; // Start bit
                tx_busy = 1;
            end
            // else next_state = Idle;
        end
        // Start: begin
        //     tx_line = 0; // Start bit
        //     tx_busy = 1;
        //     if (clk) next_state = Data;
        //     // else next_state = Start;
        // end
        // Data: begin
        //     tx_line = data_in[Dctr]; // serially transmitting data
        //     if (Dctr == 3'b111) begin
        //         next_state = Stop;
        //     end else begin
        //         next_state = Data;
        //         Dctr = Dctr + 1;
        //     end
        // end
        // Stop: begin
        //     tx_line = 1;
        //     if (clk) next_state = Idle;
        //     // else next_state = Stop;
        // end
    endcase
end

endmodule


// // reset: is sequential signal, used to immediately halt and return to idle
// // procedural block that executes every clock cycle
// always @(posedge clk or posedge reset) begin
//     if(reset) begin
//         state <= Idle;
//         next_state <= Idle;
//         Dctr <= 3'b000;
//     end else begin
//         state <= next_state;
//     end

//     if (state == Start) begin
//         tx_line = 0; // Start bit
//         tx_busy = 1;
//         if (clk) next_state = Data;
//         // else next_state = Start;
//     end
//     if (state == Data) begin
//         tx_line = data_in[Dctr]; // serially transmitting data
//         if (Dctr == 3'b111) begin
//             next_state = Stop;
//         end else begin
//             next_state = Data;
//             Dctr = Dctr + 1;
//         end
//     end
//     if (state == Stop) begin
//         tx_line = 1;
//         if (clk) next_state = Idle;
//         // else next_state = Stop;
//     end
// end

// // sensitivity list contains all the combinational logic inputs
// always @(state, tx_start, Dctr) begin 
//     case(state)
//         Idle: begin
//             tx_line = 1;
//             tx_busy = 0;
//             if (tx_start) next_state = Start;
//             // else next_state = Idle;
//         end
//         // Start: begin
//         //     tx_line = 0; // Start bit
//         //     tx_busy = 1;
//         //     if (clk) next_state = Data;
//         //     // else next_state = Start;
//         // end
//         // Data: begin
//         //     tx_line = data_in[Dctr]; // serially transmitting data
//         //     if (Dctr == 3'b111) begin
//         //         next_state = Stop;
//         //     end else begin
//         //         next_state = Data;
//         //         Dctr = Dctr + 1;
//         //     end
//         // end
//         // Stop: begin
//         //     tx_line = 1;
//         //     if (clk) next_state = Idle;
//         //     // else next_state = Stop;
//         // end
//     endcase
// end

// endmodule
