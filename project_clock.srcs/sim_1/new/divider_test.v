`timescale 1ns / 100ps

module divider_test(
    );
    reg clk = 0;
    always #1 clk = ~clk;
    
    reg dir = 0;
    
    wire out;
    wire [7:0] count;
    
    frequency_divider u_div(
        .clk_in(clk),
        .reset(1),
        .div(10),
        .direction(dir),  // 0=递增，1=递减
        .clk_out(out),
        .count(count)
    );
    
    initial begin
        #54 dir = 1;
        #6  dir = 0;
        #12 dir = 1;
        #10 $finish;
    end
endmodule
