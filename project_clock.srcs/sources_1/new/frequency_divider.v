module frequency_divider(
    input clk_in,
    input reset,
    input [7:0] div,
    output reg clk_out,
    output reg [7:0] count = 0
    );
    wire [7:0] div_1, div_2;
    assign div_1 = div - 1;
    assign div_2 = div / 2 - 1;
//    assign clk_out = (count <= div_2);
    
    always @(posedge clk_in or negedge reset)
        if(!reset) begin
            count <= 0;
            clk_out <= 1;
        end else begin
            count <= count + 1;
            if(count == div_1) begin
                count <= 0;
                clk_out <= 1;
            end else if(count == div_2)
                clk_out <= 0;
        end
endmodule

module fast_divider (
        input clk_in,
        output reg clk_out
    );
    // 10000 div
    
    reg [12:0] count;
    always @(posedge clk_in) begin
        count <= count + 1;
        
        // 2169..7168(13'b1_1100_0000_0000)
        if(count[12:10] == 3'b111) begin
            count <= 2169;
            clk_out = ~clk_out;
        end
    end
endmodule 