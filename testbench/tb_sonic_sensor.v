`timescale 1ns / 1ps

module tb_sonic_sensor;

reg clk;
reg rst_n;
reg echo;
reg btn;
wire trigger;
wire [32:0] distance;

top_sonic_sensor u_sonic (
    .clk(clk),
    .rst_n(rst_n),
    .echo(echo),
    .btn(btn),
    .trigger(trigger),
    .distance(distance)
);

always 
#5 clk = ~clk;

initial begin
    clk = 0;
    rst_n = 1;
    echo = 0;
    btn = 0;
#10
    rst_n = 0;
#10
    rst_n = 1;
#10
    btn = 1;
#10
    btn = 0;
#50005000
    echo = 1;
#15000
    echo = 0;
#50100000
    echo = 1;
#200000 
    echo = 0;
#10000000
    $finish;
end

endmodule
