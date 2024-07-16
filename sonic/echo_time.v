`timescale 1ns / 1ps

module echo_time (
    input clk,
    input rst_n,
    input echo,
    input i_idle,
    output [31:0] echo_time,
    output e_done,
    output re_idle
);

reg [31:0] r_echo_cnt;
reg [31:0] r_echo_time;
reg old_echo;
reg echo_done;
reg r_re_idle;

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        r_echo_cnt <= 0;
        r_echo_time <= 0;
        echo_done <= 0;
        old_echo <= 0;
        r_re_idle <= 0;
    end else if (echo == 1) begin
        r_echo_cnt <= r_echo_cnt + 1;
        old_echo <= 1;
    end else if (echo == 0 && old_echo == 1) begin
        r_echo_time <= r_echo_cnt;
        echo_done <= 1;
        old_echo <= 0;
        r_echo_cnt <= 0;
    end else if (r_echo_cnt > 3800000) begin
        r_echo_time <= 0;
        r_echo_cnt <= 0;
        old_echo <= 0;
        r_re_idle <= 1;
    end else if (i_idle == 1) begin
        r_echo_cnt <= 0;
        r_echo_time <= 0;
        echo_done <= 0;
        r_re_idle <= 0;
    end else begin
        r_echo_cnt <= 0;
        r_echo_time <= 0;
        echo_done <= 0;
        r_re_idle <= 0;
    end        
end 

assign echo_time = r_echo_time;
assign e_done = echo_done;
assign re_idle = r_re_idle;

endmodule