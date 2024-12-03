`timescale 1ns / 1ps

module clock_copy(
        input En,
        input target,
        input clk_mol,
        input [5:0] a_h, a_m, a_s,
        input [5:0] b_h, b_m, b_s,
        output a_clk_h, a_clk_m, a_clk_s, a_en,
        output b_clk_h, b_clk_m, b_clk_s, b_en,
        output done
    );
    wire clk_en;
//    and(clk_en, En, clk_mol);
    assign clk_en = En && clk_mol;
    
    assign a_en = ~(En && ~target);
    assign b_en = ~(En && target);
    
    demultiplexer_2 dem_h(target, clk_en && (a_h != b_h), a_clk_h, b_clk_h);
    demultiplexer_2 dem_m(target, clk_en && (a_m != b_m), a_clk_m, b_clk_m);
    demultiplexer_2 dem_s(target, clk_en && (a_s != b_s), a_clk_s, b_clk_s);
    
    and(done, En, a_h == b_h, a_m == b_m, a_s == b_s);
endmodule
