`timescale 1ns / 1ps

module hourly_led_bell(
    input [5:0] count_hr, count_min, count_sec,
    input clk_timing,
    output led
    );
    /*
     * Hourly LED Bell
     *
     * blinking n times when n o'clock (12-hours)
     * 2 Hz = 80 / 40
     */
    wire w_led;
    frequency_divider(
        .clk_in(clk_timing),
        .reset(1),
        .div(40),
        .clk_out(w_led)
    );
    
    wire enable;
    wire [5:0] now_hr;
    reg [3:0] count = 0;
    assign now_hr = (count_hr == 0 || count_hr == 12) ? 12 : count_hr % 12;
    assign enable = (count_min == 0) && (count != now_hr);
    assign led = w_led && enable;
    
    always @(posedge w_led) begin
        if(count_min == 0) begin
            if(enable)
                count <= count + 1;
        end else
            count <= 0;
    end
//    assign led = ((count_min == 0) && (count_sec == 0)) ? w_led : 0;
endmodule
