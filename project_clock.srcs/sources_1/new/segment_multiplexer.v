module segment_multiplexer(
        input En,
        input clk,
        input [7:0] Disable,
        input [6:0] Sig0, Sig1, Sig2, Sig3, Sig4, Sig5, Sig6, Sig7,
        input Dp0, Dp1, Dp2, Dp3, Dp4, Dp5, Dp6, Dp7,
        output [6:0] Ysig,
        output Ydp,
        output [7:0] Yen
    );
    reg [7:0] Sw = 8'b10000000;
    always @(posedge clk) begin
        if (Sw == 8'b00000001)
            Sw <= 8'b10000000;
       else Sw <= Sw >> 1;
    end
    
    assign Yen = En ? (~Sw | Disable) : 8'b01111110;
    assign Ydp = En ? (Sw & {Dp7, Dp6, Dp5, Dp4, Dp3, Dp2, Dp1, Dp0}) == 0 : 1;
    assign Ysig = En ? 
                  (Sw[0] ? Sig0 :
                  (Sw[1] ? Sig1 :
                  (Sw[2] ? Sig2 :
                  (Sw[3] ? Sig3 :
                  (Sw[4] ? Sig4 :
                  (Sw[5] ? Sig5 :
                  (Sw[6] ? Sig6 :
                  (Sw[7] ? Sig7 : 7'b1111111))))))))
                  : 7'b1111111;
endmodule
