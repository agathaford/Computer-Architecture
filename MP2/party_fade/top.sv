`include "fade.sv"
`include "pwm.sv"

// Top-level module to cycle RGB LED through HSV color wheel
module top #(
    parameter PWM_INTERVAL = 1200       // CLK frequency is 12MHz, so 1,200 cycles is 100us
)(
    input logic clk, 
    output logic RGB_R,
    output logic RGB_G,
    output logic RGB_B
);

    logic [$clog2(PWM_INTERVAL) - 1:0] pwm_value_r, pwm_value_g, pwm_value_b;
    logic pwm_out_r, pwm_out_g, pwm_out_b;

    fade #(
        .PWM_INTERVAL   (PWM_INTERVAL)
    ) u1 (
        .clk            (clk), 
        .pwm_value_r    (pwm_value_r),
        .pwm_value_g    (pwm_value_g),
        .pwm_value_b    (pwm_value_b)
    );

    pwm #(
        .PWM_INTERVAL   (PWM_INTERVAL)
    ) u2 (
        .clk            (clk), 
        .pwm_value      (pwm_value_r), 
        .pwm_out        (pwm_out_r)
    );
    
    pwm #(
        .PWM_INTERVAL   (PWM_INTERVAL)
    ) u3 (
        .clk            (clk), 
        .pwm_value      (pwm_value_g), 
        .pwm_out        (pwm_out_g)
    );
    
    pwm #(
        .PWM_INTERVAL   (PWM_INTERVAL)
    ) u4 (
        .clk            (clk), 
        .pwm_value      (pwm_value_b), 
        .pwm_out        (pwm_out_b)
    );

    assign RGB_R = ~pwm_out_r;
    assign RGB_G = ~pwm_out_g;
    assign RGB_B = ~pwm_out_b;

endmodule