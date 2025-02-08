// RGB LED Party Lights

module top(
    input logic clk,
    output logic RGB_R,
    output logic RGB_G,
    output logic RGB_B
);

    parameter TOTAL_CYCLES_PER_COLOR = 2000000; // 12MHz divided by 6
    logic [$clog2(TOTAL_CYCLES_PER_COLOR) - 1:0] count = 0;
    logic [2:0] color_state = 0;

    always_ff @(posedge clk) begin
        if (count == TOTAL_CYCLES_PER_COLOR - 1) begin
            count <= 0;
            // Reset color state after the last valid state (5)
            if (color_state == 3'd5) 
                color_state <= 0;
            else 
                color_state <= color_state + 1;
        end else begin
            count <= count + 1;
        end
    end

    // Color mapping based on state
    always_comb begin
        case (color_state)
            3'd0: {RGB_R, RGB_G, RGB_B} = 3'b010; // Red
            3'd1: {RGB_R, RGB_G, RGB_B} = 3'b101; // Yellow
            3'd2: {RGB_R, RGB_G, RGB_B} = 3'b110; // Green
            3'd3: {RGB_R, RGB_G, RGB_B} = 3'b011; // Cyan
            3'd4: {RGB_R, RGB_G, RGB_B} = 3'b100; // Blue
            3'd5: {RGB_R, RGB_G, RGB_B} = 3'b001; // Magenta
            default: {RGB_R, RGB_G, RGB_B} = 3'b000; // Off as fallback
        endcase
    end

endmodule
