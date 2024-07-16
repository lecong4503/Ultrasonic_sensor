`timescale 1ns / 1ps
 
module time_gen (
    input clk,
    input rst_n,
    input i_idle,
    input i_run,
    output us_tick,
    output ms_tick
);

wire w_us_tick;

reg [13:0] r_us_cnt;
reg r_ms_tick;

// us_tick instance
us_tick u_tick (
    .clk(clk),
    .rst_n(rst_n),
    .i_run(i_run),
    .i_idle(i_idle),
    .us_tick(w_us_tick)
);

// ms_tick
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        r_us_cnt <= 0;
        r_ms_tick <= 0;
    end else if (w_us_tick) begin
        if (r_us_cnt == 999) begin
            r_ms_tick <= 1;
            r_us_cnt <= 0;
        end else begin
            r_ms_tick <= 0;
            r_us_cnt <= r_us_cnt + 1;
        end
    end else if (i_idle) begin
        r_ms_tick <= 0;
        r_us_cnt <= 0;
    end else begin
        r_ms_tick <= 0;
    end
end

assign us_tick = w_us_tick;
assign ms_tick = r_ms_tick;

endmodule
