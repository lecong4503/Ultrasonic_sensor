`timescale 1ns / 1ps
 
module time_gen (
    input clk,
    input rst_n,
    input i_idle,
    input i_run,
    output [13:0] us_cnt,
    output [5:0] ms_cnt
);

reg [6:0] clk_cnt;
reg r_us_tick;
reg r_ms_tick;

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_cnt <= 0;
        r_us_tick <= 0;
    end else if (i_run) begin
        if (clk_cnt == 99) begin
            clk_cnt <= 0;
            r_us_tick <= 1;
        end else begin
            clk_cnt <= cnt_clk + 1;
            r_us_tick <= 0;
        end
    end
end

endmodule