`timescale 1ns / 1ps

module onboard(
        input clk,
        input BTN_SETTINGS, BTN_LEFT, BTN_RIGHT, BTN_CONFIRM, BTN_CANCEL,
        input Sw_debug_clk_fast, Sw_debug_clk_12, Sw_debug_time_set,
        input Sw_debug_set_hr, Sw_debug_set_min, Sw_debug_set_sec,
        input Sw_debug_clock_hr, Sw_debug_clock_min, Sw_debug_clock_sec,
        output CA, CB, CC, CD, CE, CF, CG, DP,
        output [7:0] AN,
        output LED, LED_ALERT_R, LED_ALERT_B
    );    
    wire clk_0, clk_module, clk_timing;
    clk_wiz_0(
        .clk_in1(clk),
        .clk_out1(clk_0)
    ); // 5 Mhz
    frequency_divider(
        .clk_in(clk_0),
        .clk_out(clk_module),
        .reset(1),
        .div(250)
    ); // 20 kHz
    frequency_divider(
        .clk_in(clk_module),
        .clk_out(clk_timing),
        .reset(1),
        .div(250)
    ); // 80 Hz
    
    wire btn_settings, btn_left, btn_right, btn_confirm, btn_cancel;
    button_debouncer(clk_module, BTN_SETTINGS, btn_settings);
    button_debouncer(clk_module, BTN_LEFT, btn_left);
    button_debouncer(clk_module, BTN_RIGHT, btn_right);
    button_debouncer(clk_module, BTN_CONFIRM, btn_confirm);
    button_debouncer(clk_module, BTN_CANCEL, btn_cancel);
//    assign LED_debug = btn_confirm;
//    assign LED_debug2 = BTN_CONFIRM;
    
    wire clk_clock;
    multiplexer_2 mux_clk_fast(Sw_debug_clk_fast, clk_timing, clk_module, clk_clock);
    
    wire [5:0] w_sec, w_min, w_hr;
    reg [3:0] w_cus_h, w_cus_l;
    wire [7:0] w_dps;
    wire [7:0] w_disable;
    wire [1:0] type;
    assign type = (Sw_debug_set_hr || Sw_debug_set_min || Sw_debug_set_sec) ? 1 : (
                  (Sw_debug_clock_hr || Sw_debug_clock_min || Sw_debug_clock_sec) ? 2 : 0);
    
    wire [5:0] clock_sec, clock_min, clock_hr;
    wire [7:0] clock_dps, clock_disable;
    wire clock_rst_hr, clock_rst_min, clock_rst_sec, clock_enable;
    wire [7:0] set_disable;
    
    wire [5:0] alert_sec, alert_min, alert_hr;
    wire [7:0] alert_disable;
    func_basic_clock mol_clock(
        .clk_80(clk_clock),
        .reset(1),
        .enable(clock_enable),
//        .display_custom_h(w_cus_h), .display_custom_l(w_cus_l),
        .display_hr(clock_hr), .display_min(clock_min), .display_sec(clock_sec),
        .display_points(clock_dps),
        .display_disable(clock_disable),
        .clk_rst_hr(clock_rst_hr), .clk_rst_min(clock_rst_min), .clk_rst_sec(clock_rst_sec)
//        .is_12_clock(Sw_debug_clk_12)
    );
//    time_sync sync(
//        .enable(type == 1),
//        .clk_mol(clk_module), .clk_80(clk_clock),
//        .btn_add(btn_right), .btn_minus(btn_left), .btn_reset(btn_cancel), .btn_confirm(btn_confirm),
//        .src_hr(clock_hr), .src_min(clock_min), .src_sec(clock_sec),
//        .clk_rst_hr(clock_rst_hr), .clk_rst_min(clock_rst_min), .clk_rst_sec(clock_rst_sec), .clk_rst_en(clock_enable),
////        .clock_control(),
//        .display_disable(set_disable)
//    );
    time_sync sync(
        .clk_mol(clk_module),
        .clk_80(clk_clock),
        .enable(type == 1),
//        output reg [3:0] display_custom_h, display_custom_l,
//        output reg [5:0] display_hr, display_min, display_sec,
//        output [7:0] display_points,
        .display_disable(set_disable),
        .btn_add(btn_right), .btn_minus(btn_left), .sw_hr(Sw_debug_set_hr), .sw_min(Sw_debug_set_min), .sw_sec(Sw_debug_set_sec),
        .clk_rst_hr(clock_rst_hr), .clk_rst_min(clock_rst_min), .clk_rst_sec(clock_rst_sec),
        .clk_rst_en(clock_enable)
    );
    alert_clock alert(
        .clk_mol(clk_module),
        .clk_80(clk_clock),
        .enable(1),
        .setting(type == 2),
//        output reg [3:0] display_custom_h, display_custom_l,
        .display_hr(alert_hr), .display_min(alert_min), .display_sec(alert_sec),
//        output [7:0] display_points,
        .display_disable(alert_disable),
        .btn_add(btn_right), .btn_minus(btn_left), .sw_hr(Sw_debug_clock_hr), .sw_min(Sw_debug_clock_min), .sw_sec(Sw_debug_clock_sec),
        .src_hr(clock_hr), .src_min(clock_min), .src_sec(clock_sec),
        .led_alert({LED_ALERT_R, LED_ALERT_B})
    );
    assign w_disable = (type == 0) ? clock_disable : (
                       (type == 1) ? set_disable : (
                       (type == 2) ? alert_disable : 0));
    assign w_sec = (type == 0) ? clock_sec : (
                   (type == 1) ? clock_sec : (
                   (type == 2) ? alert_sec : 0));
    assign w_min = (type == 0) ? clock_min : (
                   (type == 1) ? clock_min : (
                   (type == 2) ? alert_min : 0));
    assign w_hr  = (type == 0) ? clock_hr : (
                   (type == 1) ? clock_hr : (
                   (type == 2) ? alert_hr : 0)); 
    
    hourly_led_bell(
        .count_hr(clock_hr), .count_min(clock_min), .count_sec(clock_sec),
        .clk_timing(clk_clock), 
        .led(LED)
    );
    
    //12-hours converter
    reg[5:0] r_hr, hr_12;
    always @(Sw_debug_clk_12 or w_hr) begin
        if(!Sw_debug_clk_12) begin
            r_hr <= w_hr[5:0];
            w_cus_h <= 4'hF;
            w_cus_l <= 4'hF;
        end 
        else begin
            hr_12 = w_hr[5:0] % 12;
            w_cus_l <= 4'hC;
            w_cus_h <= 4'hA + (hr_12 != w_hr[5:0]);
            r_hr <= (hr_12 != 0) ? hr_12 : 5'd12;
        end
    end
    
    wire [6:0] seg_cus_h, seg_cus_l, seg_hr_h, seg_hr_l, seg_min_h, seg_min_l, seg_sec_h, seg_sec_l;
    segment_display dis_cus_h(
        .Num(w_cus_h),
        .Y(seg_cus_h)
    );
    segment_display dis_cus_l(
        .Num(w_cus_l),
        .Y(seg_cus_l)
    );
    bcd_display dis_sec(
        .Num(w_sec),
        .SegH(seg_sec_h),
        .SegL(seg_sec_l)
    );
    bcd_display dis_min(
        .Num(w_min),
        .SegH(seg_min_h),
        .SegL(seg_min_l)
    );
    bcd_display dis_hr(
        .Num(r_hr),
        .SegH(seg_hr_h),
        .SegL(seg_hr_l)
    );
    
    wire clk_scan;
    frequency_divider div_scan(
        .clk_in(clk_module),
        .clk_out(clk_scan),
        .reset(1),
        .div(8)
    );  // 1,250 Hz / 8 segment
    segment_multiplexer display(
        .En(1),
        .clk(clk_scan),
        .Disable(w_disable),
        .Sig7(seg_cus_h),.Sig6(seg_cus_l),.Sig5(seg_hr_h),.Sig4(seg_hr_l),.Sig3(seg_min_h),.Sig2(seg_min_l),.Sig1(seg_sec_h),.Sig0(seg_sec_l),
        .Dp7(w_dps[7]), .Dp6(w_dps[6]), .Dp5(w_dps[5]), .Dp4(w_dps[4]), .Dp3(w_dps[3]), .Dp2(w_dps[2]), .Dp1(w_dps[1]), .Dp0(w_dps[0]), 
        .Ysig({CA, CB, CC, CD, CE, CF, CG}),
        .Ydp(DP),
        .Yen(AN)
    );
endmodule
