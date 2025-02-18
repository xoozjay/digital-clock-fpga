module func_basic_clock(
        input clk_80,
        input reset,
        input enable,
        output reg [3:0] display_custom_h, display_custom_l,
        output [5:0] display_hr, display_min, display_sec,
        output [7:0] display_points,
        output [7:0] display_disable,
        
        input clk_rst_hr, clk_rst_min, clk_rst_sec
//        input is_12_clock
    );
    /**
     * Basic Clock Module
     * 
     * input clk_80 is a 80Hz clock.
     * when reset == 0, clock will reset
     * when enable == 1, clock operates normally, otherwise the carry for hours and minutes is disconnected.
     * when enable == 0 && reset == 1,
     *     clk_rst_sec posedge will reset second to 0;
     *     clk_rst_min/clk_rst_hr posedge will add 1 to corresponding count(no carry).
     */
     
    wire [7:0] w_sec, w_min, w_hr;
    wire clk_sec, clk_min, clk_hr;
    wire clk_timing_sec, clk_timing_min, clk_timing_hr;
    assign clk_sec = clk_timing_sec;
//    wire clk_day;
//    multiplexer_2 m_s(enable, clk_rst_sec, clk_timing_sec, clk_sec);
    reg clk_buf_min, clk_buf_hr;
    always @(posedge clk_80 or posedge enable) begin
        if(enable) begin
            clk_buf_min <= clk_timing_min;
            clk_buf_hr  <= clk_timing_hr;
        end
    end
    assign clk_min = enable ? clk_timing_min : clk_rst_min ^ clk_buf_min;
    assign clk_hr  = enable ? clk_timing_hr  : clk_rst_hr  ^ clk_buf_hr;

    frequency_divider div_s(
        .clk_in(clk_80),
        .clk_out(clk_timing_sec),
        .reset(reset),
        .div(80)
    );
    frequency_divider div_sec(
        .clk_in(clk_sec),
        .clk_out(clk_timing_min),
        .reset(reset && ~clk_rst_sec),
        .div(60),
        .count(w_sec)
    );
    frequency_divider div_min(
        .clk_in(clk_min),
        .clk_out(clk_timing_hr),
        .reset(reset),
        .div(60),
        .count(w_min)
    );
    frequency_divider div_hr(
        .clk_in(clk_hr),
//        .clk_out(clk_day),
        .reset(reset),
        .div(24),
        .count(w_hr)
    );
    
//    reg [5:0] hr_12;
//    always @(is_12_clock or w_hr) begin
//        if(!is_12_clock) begin
//            display_hr <= w_hr[5:0];
//            display_custom_h <= 4'hF;
//            display_custom_l <= 4'hF;
//        end 
//        else begin
//            hr_12 = w_hr[5:0] % 12;
//            display_custom_l <= 4'hC;
//            display_custom_h <= 4'hA + (hr_12 != w_hr[5:0]);
//            display_hr <= (hr_12 != 0) ? hr_12 : 5'd12;
//        end
//    end
    assign display_hr = w_hr[5:0];
    assign display_min = w_min[5:0];
    assign display_sec = w_sec[5:0];
    assign display_points = 8'b00000000;
    assign display_disable = 8'b00000000;
endmodule 