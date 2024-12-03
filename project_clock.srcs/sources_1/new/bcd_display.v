module bcd_display(
    input [5:0] Num,
    output [6:0] SegH,
    output [6:0] SegL
    );
    wire [3:0] numH, numL;
    segment_display sdh(
            .Num(numH),
            .Y(SegH)
            );
    segment_display sdl(
            .Num(numL),
            .Y(SegL)
            );

    assign numH = Num / 10;
    assign numL = Num % 10;
endmodule
