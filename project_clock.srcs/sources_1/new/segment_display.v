`timescale 1ns / 1ps

module segment_display(
    input [3:0] Num,
    output reg [6:0] Y
    );
    
//    common anode
    always @(Num) begin
        case(Num)
            4'h0: Y <= 7'b0000001;
            4'h1: Y <= 7'b1001111;
            4'h2: Y <= 7'b0010010;
            4'h3: Y <= 7'b0000110;
            4'h4: Y <= 7'b1001100;
            4'h5: Y <= 7'b0100100;
            4'h6: Y <= 7'b0100000;
            4'h7: Y <= 7'b0001111;
            4'h8: Y <= 7'b0000000;
            4'h9: Y <= 7'b0000100;
            4'hA: Y <= 7'b0001000;  //A
            4'hB: Y <= 7'b0011000;  //P
            4'hC: Y <= 7'b0110001;  //C
            4'hD: Y <= 7'b0100100;  //S
            4'hF: Y <= 7'b1111111;  //none
            default Y <= 7'b1111111;
        endcase
    end
endmodule
