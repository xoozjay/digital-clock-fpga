module time_sync(
        input clk_mol,
        input clk_timing,
//        input reset,
        input enable,
//        output reg [3:0] display_custom_h, display_custom_l,
//        output reg [5:0] display_hr, display_min, display_sec,
//        output [7:0] display_points,
        output reg [7:0] display_disable,
        input btn_add, btn_minus, sw_hr, sw_min, sw_sec,
        output clk_rst_hr, clk_rst_min, clk_rst_sec, clk_rst_en
//        input [5:0] src_hr, src_min, src_sec
    );
    parameter integer DIV_FACTOR_SECOND = 100;
    
    assign clk_rst_en = ~enable;
    
    wire clk_disable_blink;
    frequency_divider div_disable(
        .clk_in(clk_timing),
        .reset(enable),
        .div(DIV_FACTOR_SECOND / 2),
        .clk_out(clk_disable_blink)
    );
    always @(clk_disable_blink) begin
        if(clk_disable_blink) begin
                 if(sw_hr ) display_disable <= 8'b00110000;
            else if(sw_min) display_disable <= 8'b00001100;
            else if(sw_sec) display_disable <= 8'b00000011;
        end else            display_disable <= 0;
    end
    
//    reg [5:0] count;
    assign clk_rst_hr = enable && sw_hr && btn_add;
    assign clk_rst_min = enable && ~sw_hr && sw_min && btn_add;
    assign clk_rst_sec = enable && ~sw_hr && ~sw_min && sw_sec && btn_add;
//    always @(posedge btn_add or posedge btn_minus)
//        if(enable && (btn_add ^ btn_minus) && (count == 0)) begin
//            if(btn_add)
//                count <= 1;
//            else if (btn_minus)
//                count <= 59;
//        end
        
//    always @(posedge clk_mol)
//        if(enable && (count != 0)) begin
//            count <= count - 1;
//        end
endmodule 

module alert_clock (
        input clk_mol,
        input clk_timing,
        input setting,
        input enable,
//        output reg [3:0] display_custom_h, display_custom_l,
        output [5:0] display_hr, display_min, display_sec,
//        output [7:0] display_points,
        output [7:0] display_disable,
        input btn_add, btn_minus, sw_hr, sw_min, sw_sec,
        input [5:0] src_hr, src_min, src_sec,
        output [1:0] led_alert
    );
    reg [5:0] alert_hr = 0, alert_min = 1, alert_sec = 20;
    assign display_hr = alert_hr;
    assign display_min = alert_min;
    assign display_sec = alert_sec;
    
    wire clk_rst_hr, clk_rst_min, clk_rst_sec;
    time_sync(
        .clk_mol(clk_mol),
        .clk_timing(clk_timing),
        .enable(setting && enable),
        .display_disable(display_disable),
        .btn_add(btn_add), .btn_minus(btn_minus), .sw_hr(sw_hr), .sw_min(sw_min), .sw_sec(sw_sec),
        .clk_rst_hr(clk_rst_hr), .clk_rst_min(clk_rst_min), .clk_rst_sec(clk_rst_sec)
//        input [5:0] src_hr, src_min, src_sec
    );
    always @(posedge clk_rst_hr)
        if(clk_rst_hr)
            alert_hr <= (alert_hr + 1) % 24;
    always @(posedge clk_rst_min)
        if(clk_rst_min)
            alert_min <= (alert_min + 1) % 60;
    always @(posedge clk_rst_sec)
        if(clk_rst_sec)
            alert_sec <= (alert_sec + 1) % 60;
    
    wire trigger;
    assign trigger = enable && (alert_hr == src_hr) && (alert_min == src_min) && (alert_sec == src_sec);
    wire btn_stop_alert;
    assign btn_stop_alert = btn_add || btn_minus;
    reg alert_enable;
    always @(posedge trigger or posedge btn_stop_alert) begin
        if(btn_stop_alert)
            alert_enable <= 0;
        else if(trigger)
            alert_enable <= 1;
    end
    
    wire clk_alert;
    reg [1:0] led_alert_r = 0;
    assign led_alert = alert_enable ? led_alert_r : 0;
    frequency_divider alert(
        .clk_in(clk_timing),
        .clk_out(clk_alert),
        .reset(alert_enable),
        .div(10)
    );
    always @(posedge clk_alert)
        led_alert_r <= enable ? (led_alert_r + 1) : 0;
endmodule 