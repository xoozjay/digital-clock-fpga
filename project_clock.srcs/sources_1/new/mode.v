module mode_controller(
    input reset,
    input btn_settings,
    input btn_confirm,
    output reg [1:0] mode,
    output set_hr, set_min, set_sec,
    output alert_hr, alert_min, alert_sec
);
    localparam MODE_CLOCK = 0;
    localparam MODE_SET   = 1;
    localparam MODE_ALERT = 2;

    localparam SEL_HR = 0;
    localparam SEL_MIN = 1;
    localparam SEL_SEC = 2;

    reg [1:0] sel;

    // 主模式状态机
    always @(posedge btn_settings or negedge reset) begin
        if(!reset)
            mode <= MODE_CLOCK;
        else
            case(mode)
                MODE_CLOCK: mode <= MODE_SET;
                MODE_SET:   mode <= MODE_ALERT;
                MODE_ALERT: mode <= MODE_CLOCK;
                default:    mode <= 0;
            endcase
    end

    // 设置项选择逻辑
    always @(posedge btn_confirm or negedge reset) begin
        if(!reset) 
            sel <= 0;
        else
            case(sel)
                SEL_HR:  sel <= SEL_MIN;
                SEL_MIN: sel <= SEL_SEC;
                SEL_SEC: sel <= SEL_HR;
                default: sel <= 0;
            endcase
    end
    
    assign set_hr  = mode == MODE_SET && sel == SEL_HR;
    assign set_min = mode == MODE_SET && sel == SEL_MIN;
    assign set_sec = mode == MODE_SET && sel == SEL_SEC;
    assign alert_hr  = mode == MODE_ALERT && sel == SEL_HR;
    assign alert_min = mode == MODE_ALERT && sel == SEL_MIN;
    assign alert_sec = mode == MODE_ALERT && sel == SEL_SEC;
endmodule