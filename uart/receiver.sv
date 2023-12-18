module receiver (
    input wire rx_clk, // Oversampling clock
    input wire rx_serial, // Serial input from TX
    input wire reset,
    output reg [7:0] rx_data, // Received byte
    output reg rx_done, // High when a byte is received
    output reg framing_error
);
    // Define states
    typedef enum {
        Idle, Start, Rcv_Data, Stop, Error
    } states_t;

    reg [2:0] state = Idle; // Current state
    reg [3:0] bit_index = 3'd0; // Bit index of the data being received
    reg [3:0] sample_count = 4'd0; // Counts the number of samples for each bit
    reg [7:0] shift_reg = 8'd0; // Shift register to temporarily hold the incoming bits

    // Number of samples per bit is 16
    localparam integer SAMPLES_PER_BIT = 15;
    // Halfway point to sample a bit, you might adjust this for better performance
    localparam integer SAMPLE_POINT = 7;

    // State machine
    always @(posedge rx_clk or posedge reset) begin
        if (reset) begin
            framing_error <= 0;
            state <= Idle;
            rx_data <= 8'd0;
            rx_done <= 1'b0;
            bit_index <= 3'd0;
            sample_count <= 4'd0;
            shift_reg <= 8'd0;
        end else begin
            case (state)
                Idle: begin
                    if (!rx_serial) begin // Detect start bit (usually low)
                        state <= Start;
                        sample_count <= 4'd0; // Start sampling
                    end
                end
                Start: begin
                  sample_count <= sample_count + 1;
                  if (sample_count == SAMPLE_POINT) begin
                      if (!rx_serial) begin // Confirm start bit
                          // dont reset because it will be at 7 so we sample 8 more bits to get 
                          // 15th bit which is middle point of first bit of data
                          state <= Rcv_Data;
                          bit_index <= 3'd0;
                          sample_count <= 4'd0;
                      end else begin
                          state <= Idle;
                      end
                  end
                end
                Rcv_Data: begin
                  sample_count <= sample_count + 1;
                  // If we reach 16 bits we set bit into reg
                  if (sample_count == SAMPLES_PER_BIT) begin
                      shift_reg[bit_index] <= rx_serial; // Sample the data bit
                      bit_index <= bit_index + 1;
                      sample_count <= 4'd0;
                      if (bit_index == 3'd7) begin
                          sample_count <= 4'd0; // Reset sample count
                          state <= Stop;
                      end
                  end
                end
                Stop: begin
                  sample_count <= sample_count + 1;
                    // If we reach 7 bits we finish.
                    if (sample_count == SAMPLES_PER_BIT) begin
                        if (rx_serial) begin // Verify stop bit
                            rx_data <= shift_reg;
                            rx_done <= 1'b1;
                            state <= Idle;
                            framing_error <= 0;
                        end else begin
                            state <= Error;
                        end
                    end
                end
                Error: begin
                    // Error handling here
                    state <= Idle; // For now, simply return to Idle
                    framing_error <= 1;
                end
            endcase
        end
    end
endmodule
