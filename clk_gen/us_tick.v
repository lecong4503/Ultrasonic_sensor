`timescale 1ns / 1ps

module us_tick (
    input clk,
    input rst_n,
    input i_run,
    input i_idle,
    output us_tick
);

reg [6:0] r_cnt;
reg r_us_tick;

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        r_cnt <= 0;
        r_us_tick <= 0;
    end else if (i_run) begin
        if (r_cnt == 99) begin
            r_cnt <= 0;
            r_us_tick <= 1;
        end else begin
            r_cnt <= r_cnt + 1;
            r_us_tick <= 0;
        end
    end else if (i_idle) begin
        r_cnt <= 0;
        r_us_tick <= 0;
    end else begin
        r_us_tick <= 0;
    end
end

assign us_tick = r_us_tick;

endmodule