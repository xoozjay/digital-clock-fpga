`timescale 1ns / 1ps

module onboard(
    input clk,
    input BTN_SETTINGS, BTN_LEFT, BTN_RIGHT, BTN_CONFIRM, BTN_CANCEL,
    input Sw_debug_clk_fast, Sw_debug_clk_12,
    output CA, CB, CC, CD, CE, CF, CG, DP,
    output [7:0] AN,
    output LED, LED_ALERT_R, LED_ALERT_B
);
    parameter integer SOURCE_FREQ = 1e8;
    parameter integer
            DIV_FACTOR_MODULE = 10000, // 用于生成 clk_module 的分频系数，无实际作用，见 fast_divider
            DIV_FACTOR_TIMING = 100, // 用于生成 clk_timing 的分频系数
            DIV_FACTOR_SCAN   = 6;   // 用于扫描段选的分频系数（基于 clk_module）
            
    parameter RESET_ACTIVE = 1;      // 固定值，不要动。低电平有效

    localparam MODE_CLOCK = 0;
    localparam MODE_SET   = 1;
    localparam MODE_ALERT = 2;

    localparam [3:0] CUSTOM_H_DEFAULT    = 4'hF;
    localparam [3:0] CUSTOM_L_DEFAULT    = 4'hF;
    localparam [3:0] CUSTOM_L_SET        = 4'hC;
    localparam [3:0] CUSTOM_H_SET_OFFSET = 4'hA;

    //===========================================================================
    // 时钟生成与分频
    //===========================================================================
    wire clk_module, clk_timing;

    fast_divider u_div_module (
        .clk_in(clk),
        .clk_out(clk_module)
    ); // 10 kHz

    frequency_divider u_div_timing (
        .clk_in(clk_module),
        .clk_out(clk_timing),
        .reset(RESET_ACTIVE),
        .div(DIV_FACTOR_TIMING)
    ); // 100 Hz

    //===========================================================================
    // 按键消抖
    //===========================================================================
    wire btn_settings, btn_left, btn_right, btn_confirm, btn_cancel;
    button_debouncer u_btn_settings (.clk(clk_module), .button(BTN_SETTINGS), .debounced(btn_settings));
    button_debouncer u_btn_left     (.clk(clk_module), .button(BTN_LEFT),     .debounced(btn_left));
    button_debouncer u_btn_right    (.clk(clk_module), .button(BTN_RIGHT),    .debounced(btn_right));
    button_debouncer u_btn_confirm  (.clk(clk_module), .button(BTN_CONFIRM),  .debounced(btn_confirm));
    button_debouncer u_btn_cancel   (.clk(clk_module), .button(BTN_CANCEL),   .debounced(btn_cancel));

    //===========================================================================
    // 时钟调试多路选择器
    //===========================================================================
    wire clk_clock;
    assign clk_clock = Sw_debug_clk_fast ? clk_module : clk_timing;


    //===========================================================================
    // 模式选择：普通时钟 / 时间设定 / 闹钟模式
    //===========================================================================
    wire [1:0] mode;
    wire set_hr, set_min, set_sec;
    wire alert_hr, alert_min, alert_sec;
    mode_controller u_mode_ctrl (
        .reset(RESET_ACTIVE),
        .btn_settings(btn_settings),
        .btn_confirm(btn_confirm),
        .mode(mode),
        .set_hr(set_hr),
        .set_min(set_min),
        .set_sec(set_sec),
        .alert_hr(alert_hr),
        .alert_min(alert_min),
        .alert_sec(alert_sec)
    );

    //===========================================================================
    // 时钟模块与时间同步逻辑
    //===========================================================================
    wire [5:0] clock_sec, clock_min, clock_hr;
    wire [7:0] clock_dps, clock_disable;
    wire clock_rst_hr, clock_rst_min, clock_rst_sec, clock_enable;
    wire [7:0] set_disable;

    func_basic_clock u_mol_clock (
        .clk_timing(clk_clock),
        .reset(RESET_ACTIVE),
        .enable(clock_enable),
        .display_hr(clock_hr),
        .display_min(clock_min),
        .display_sec(clock_sec),
        .display_points(clock_dps),
        .display_disable(clock_disable),
        .clk_rst_hr(clock_rst_hr),
        .clk_rst_min(clock_rst_min),
        .clk_rst_sec(clock_rst_sec)
    );

    time_sync u_time_sync (
        .clk_mol(clk_module),
        .clk_timing(clk_clock),
        .enable(mode == MODE_SET),
        .display_disable(set_disable),
        .btn_add(btn_right),
        .btn_minus(btn_left),
        .sw_hr(set_hr),
        .sw_min(set_min),
        .sw_sec(set_sec),
        .clk_rst_hr(clock_rst_hr),
        .clk_rst_min(clock_rst_min),
        .clk_rst_sec(clock_rst_sec),
        .clk_rst_en(clock_enable)
    );

    //===========================================================================
    // 闹钟模块
    //===========================================================================
    wire [5:0] clock_alert_sec, clock_alert_min, clock_alert_hr;
    wire [7:0] alert_disable;
    alert_clock u_alert (
        .clk_mol(clk_module),
        .clk_timing(clk_clock),
        .enable(1),
        .setting(mode == MODE_ALERT),
        .display_hr(clock_alert_hr),
        .display_min(clock_alert_min),
        .display_sec(clock_alert_sec),
        .display_disable(alert_disable),
        .btn_add(btn_right),
        .btn_minus(btn_left),
        .sw_hr(alert_hr),
        .sw_min(alert_min),
        .sw_sec(alert_sec),
        .src_hr(clock_hr),
        .src_min(clock_min),
        .src_sec(clock_sec),
        .led_alert({LED_ALERT_R, LED_ALERT_B})
    );

    // 根据不同模式选择显示数据
    wire [5:0] disp_sec, disp_min, disp_hr;
    wire [7:0] disp_disable;
    assign disp_disable = (mode == MODE_CLOCK) ? clock_disable :
                          (mode == MODE_SET)   ? set_disable   :
                          (mode == MODE_ALERT) ? alert_disable : 8'd0;
    assign disp_sec = (mode == MODE_ALERT) ? clock_alert_sec : clock_sec;
    assign disp_min = (mode == MODE_ALERT) ? clock_alert_min : clock_min;
    assign disp_hr  = (mode == MODE_ALERT) ? clock_alert_hr  : clock_hr; 

    //===========================================================================
    // 每整点 LED 响铃模块
    //===========================================================================
    hourly_led_bell u_hourly_bell (
        .count_hr(clock_hr),
        .count_min(clock_min),
        .count_sec(clock_sec),
        .clk_timing(clk_clock), 
        .led(LED)
    );

    //===========================================================================
    // 12 小时制转换逻辑
    // 自定义显示标记
    //===========================================================================
    wire[3:0] w_cus_h, w_cus_l;
    wire[5:0] w_hr;
    assign w_cus_l = Sw_debug_clk_12 ? ((disp_hr < 12) ? 4'hA : 4'hB) : 4'hF;
    assign w_hr = Sw_debug_clk_12 ? ((disp_hr == 12 || disp_hr == 0) ? 12
                                                                     : (w_cus_l[0] ? disp_hr - 12 : disp_hr)) 
                                  : disp_hr;
    assign w_cus_h = (mode == MODE_SET) ? 4'hD : (
                     (mode == MODE_ALERT) ? 4'hC : (4'hF));

    //===========================================================================
    // 数码管显示模块
    //===========================================================================
    wire [6:0] seg_cus_h, seg_cus_l, seg_hr_h, seg_hr_l, seg_min_h, seg_min_l, seg_sec_h, seg_sec_l;
    segment_display u_dis_cus_h (
        .Num(w_cus_h),
        .Y(seg_cus_h)
    );
    segment_display u_dis_cus_l (
        .Num(w_cus_l),
        .Y(seg_cus_l)
    );
    bcd_display u_dis_sec (
        .Num(disp_sec),
        .SegH(seg_sec_h),
        .SegL(seg_sec_l)
    );
    bcd_display u_dis_min (
        .Num(disp_min),
        .SegH(seg_min_h),
        .SegL(seg_min_l)
    );
    bcd_display u_dis_hr (
        .Num(w_hr),
        .SegH(seg_hr_h),
        .SegL(seg_hr_l)
    );

    // 扫描频率分频器
    wire clk_scan;
    frequency_divider u_div_scan (
        .clk_in(clk_module),
        .clk_out(clk_scan),
        .reset(RESET_ACTIVE),
        .div(DIV_FACTOR_SCAN)
    );

    // 数码管段选多路复用
    wire [7:0] w_dps;
    segment_multiplexer u_display (
        .En(1),
        .clk(clk_scan),
        .Disable(disp_disable),
        .Sig7(seg_cus_h), .Sig6(seg_cus_l), .Sig5(seg_hr_h), .Sig4(seg_hr_l),
        .Sig3(seg_min_h), .Sig2(seg_min_l), .Sig1(seg_sec_h), .Sig0(seg_sec_l),
        .Dp7(w_dps[7]), .Dp6(w_dps[6]), .Dp5(w_dps[5]), .Dp4(w_dps[4]),
        .Dp3(w_dps[3]), .Dp2(w_dps[2]), .Dp1(w_dps[1]), .Dp0(w_dps[0]), 
        .Ysig({CA, CB, CC, CD, CE, CF, CG}),
        .Ydp(DP),
        .Yen(AN)
    );

endmodule