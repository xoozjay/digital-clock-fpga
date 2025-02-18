module mode_controller(
    input clk,
    input reset,
    input btn_settings,
    input btn_confirm,
    input btn_right,
    output reg [1:0] mode,
    output reg set_hr, set_min, set_sec,
    output reg alert_hr, alert_min, alert_sec
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

    // 使能信号生成
    always @(*) begin
        {set_hr, set_min, set_sec} = 3'b0;
        {alert_hr, alert_min, alert_sec} = 3'b0;
        
        case(mode)
            MODE_SET: case(sel)
                0: set_hr = 1;
                1: set_min = 1;
                2: set_sec = 1;
            endcase
            MODE_ALERT: case(sel)
                0: alert_hr = 1;
                1: alert_min = 1;
                2: alert_sec = 1;
            endcase
        endcase
    end
endmodule