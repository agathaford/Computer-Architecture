// Fade module to generate PWM values for RGB LED cycling through HSV colors
module fade #(
    parameter INC_DEC_INTERVAL = 12000,
    parameter INC_DEC_MAX = 200,
    parameter PWM_INTERVAL = 1200
)(
    input logic clk, 
    output logic [$clog2(PWM_INTERVAL) - 1:0] pwm_value_r,
    output logic [$clog2(PWM_INTERVAL) - 1:0] pwm_value_g,
    output logic [$clog2(PWM_INTERVAL) - 1:0] pwm_value_b
);

    logic [$clog2(PWM_INTERVAL) - 1:0] hue = 0;
    logic [$clog2(INC_DEC_INTERVAL) - 1:0] count = 0;

    always_ff @(posedge clk) begin
        if (count == INC_DEC_INTERVAL - 1) begin
            count <= 0;
            hue <= (hue + 1) % 360;
        end else begin
            count <= count + 1;
        end
    end

    always_comb begin
        if (hue < 120) begin
            pwm_value_r = (120 - hue) * (PWM_INTERVAL / 120);
            pwm_value_g = (hue) * (PWM_INTERVAL / 120);
            pwm_value_b = 0;
        end else if (hue < 240) begin
            pwm_value_r = 0;
            pwm_value_g = (240 - hue) * (PWM_INTERVAL / 120);
            pwm_value_b = (hue - 120) * (PWM_INTERVAL / 120);
        end else begin
            pwm_value_r = (hue - 240) * (PWM_INTERVAL / 120);
            pwm_value_g = 0;
            pwm_value_b = (360 - hue) * (PWM_INTERVAL / 120);
        end
    end
endmodule