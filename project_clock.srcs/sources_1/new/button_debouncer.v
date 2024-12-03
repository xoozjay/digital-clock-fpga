module button_debouncer (
        input clk_mol,
        input btn,
        output reg btn_out
    );
    reg btn_status = 0;
    reg [7:0] count = 0;
    always @(posedge clk_mol) begin
        if(btn_status == btn) begin
            count <= count + 1;
            if (count == 250)
                btn_out <= btn_status;
        end else begin 
            count <= 0;
            btn_status <= btn;
        end
    end
endmodule 