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

    reg [1:0] sel;

    // 主模式状态机
    always @(posedge btn_settings or negedge reset) begin
        if(!reset) begin
            mode <= MODE_CLOCK;
        end else begin
            case(mode)
                MODE_CLOCK: mode <= MODE_SET;
                MODE_SET:   mode <= MODE_ALERT;
                MODE_ALERT: mode <= MODE_CLOCK;
            endcase
        end
    end

    // 设置项选择逻辑
    always @(posedge btn_confirm or negedge reset) begin
        if(!reset) 
            sel <= 0;
        else
            sel <= (sel == 2) ? 0 : sel + 1;
    end
    
    assign set_hr  = mode == MODE_SET && sel == 0;
    assign set_min = mode == MODE_SET && sel == 1;
    assign set_sec = mode == MODE_SET && sel == 2;
    assign alert_hr  = mode == MODE_ALERT && sel == 0;
    assign alert_min = mode == MODE_ALERT && sel == 1;
    assign alert_sec = mode == MODE_ALERT && sel == 2;
endmodule