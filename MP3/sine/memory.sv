// Memory module

module memory (
    input logic clk,
    input logic [8:0] read_address,
    output logic [9:0] read_data
);

    //9-bit 1st quarter of sine wave
    logic [9:0] sample_memory [0:127];

    initial begin
        $readmemh("sine_quarter.txt", sample_memory);
    end

    always_ff @(posedge clk) begin
        case (read_address[8:7])  // Top 2 bits determines quarter
            2'b00: read_data <= sample_memory[read_address[6:0]];                // 1st quarter no changes
            2'b01: read_data <= sample_memory[127 - read_address[6:0]];          // Mirror for 2nd quarter: Value is subtracted from last index of sample
            2'b10: read_data <= (~sample_memory[read_address[6:0]] + 1'b1) + 10'd512;       // Invert for 3rd quarter: Flips all bits and add's 1 (two's complement). Then shift all values into the positive range.
            2'b11: read_data <= (~sample_memory[127 - read_address[6:0]] + 1'b1) + 10'd512; // Invert and mirror for 4th quarter.
        endcase
    end

endmodule
