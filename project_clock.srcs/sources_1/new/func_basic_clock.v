module func_basic_clock(
        input clk_timing,
        input reset,
        input enable,
        output reg [3:0] display_custom_h, display_custom_l,
        output [5:0] display_hr, display_min, display_sec,
        output [7:0] display_points,
        output [7:0] display_disable,
        
        input clk_rst_hr, clk_rst_min, clk_rst_sec
    );
    /**
     * Basic Clock Module
     * 
     * input clk_timing
     * when reset == 0, clock will reset
     * when enable == 1, clock operates normally, otherwise the carry for hours and minutes is disconnected.
     * when enable == 0 && reset == 1,
     *     clk_rst_sec posedge will reset second to 0;
     *     clk_rst_min/clk_rst_hr posedge will add 1 to corresponding count(no carry).
     */
    parameter integer DIV_FACTOR_SECOND = 100; // 用于生成秒分频
    
    wire [7:0] w_sec, w_min, w_hr;
    wire clk_sec, clk_min, clk_hr;
    wire clk_timing_sec, clk_timing_min, clk_timing_hr;
    assign clk_sec = clk_timing_sec;
//    wire clk_day;
//    multiplexer_2 m_s(enable, clk_rst_sec, clk_timing_sec, clk_sec);
    reg clk_buf_min, clk_buf_hr;
    always @(posedge clk_timing or posedge enable) begin
        if(enable) begin
            clk_buf_min <= clk_timing_min;
            clk_buf_hr  <= clk_timing_hr;
        end
    end
    assign clk_min = enable ? clk_timing_min : clk_rst_min ^ clk_buf_min;
    assign clk_hr  = enable ? clk_timing_hr  : clk_rst_hr  ^ clk_buf_hr;

    frequency_divider div_s(
        .clk_in(clk_timing),
        .clk_out(clk_timing_sec),
        .reset(reset),
        .div(DIV_FACTOR_SECOND)
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
    
    assign display_hr = w_hr[5:0];
    assign display_min = w_min[5:0];
    assign display_sec = w_sec[5:0];
    assign display_points = 8'b00000000;
    assign display_disable = 8'b00000000;
endmodule 