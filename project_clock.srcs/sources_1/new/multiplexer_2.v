`timescale 1ns / 1ps

module multiplexer_2(
        input S,
        input I1, I2,
        output Y
    );
    wire i1_w, i2_w;
    and u1(i1_w, ~S, I1);
    and u2(i2_w, S, I2);
    or u3(Y, i1_w, i2_w);
//    assign Y = S ? I2 : I1;
endmodule

module demultiplexer_2(
        input S,
        input I,
        output Y1, Y2
    );
    assign Y1 = S ? 0 : I;
    assign Y2 = S ? I : 0;
endmodule