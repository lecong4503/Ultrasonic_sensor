`timescale 1ns / 1ps

module top_time_gen (
    input clk,
    input rst_n,
    input btn,
    output [13:0] us_cnt,
    output [5:0] ms_cnt
);

wire w_run;
wire w_idle;

control u_control (
    .clk(clk),
    .rst_n(rst_n),
    .toggle(btn),
    .o_idle(w_idle),
    .o_run(w_run)
);

time_gen u_time_gen (
    .clk(clk),
    .rst_n(rst_n),
    .i_idle(w_idle),
    .i_run(w_run),
    .us_cnt(us_cnt),
    .ms_cnt(ms_cnt)
);

endmodule