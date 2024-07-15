`timescale 1ns / 1ps

module tb_time_gen;

reg clk;
reg rst_n;
reg btn;
wire us_tick;
wire ms_tick;
wire toggle;

top_time_gen u_time (
    .clk(clk),
    .rst_n(rst_n),
    .btn(btn),
    .us_tick(us_tick),
    .ms_tick(ms_tick),
    .toggle(toggle)
);

always 
#5 clk = ~clk;

initial begin
    clk = 0;
    rst_n = 1;
    btn = 0;
#10
    rst_n = 0;
#10
    rst_n = 1;
#10
    btn = 1;
#10
    btn = 0;
#5000000
    btn = 1;
#10
    btn = 0;
#10
    btn = 1;
#10
    btn = 0;
#2000000
    $finish;
end

endmodule