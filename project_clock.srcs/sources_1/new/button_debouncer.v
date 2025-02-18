module button_debouncer (
        input clk,
        input button,
        output reg debounced
    );
    reg btn_status = 0;
    reg [7:0] count = 0;
    always @(posedge clk) begin
        if(btn_status == button) begin
            count <= count + 1;
            if (count == 250)
                debounced <= btn_status;
        end else begin 
            count <= 0;
            btn_status <= button;
        end
    end
endmodule 