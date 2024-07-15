`timescale 1ns / 1ps

module trigger (
    input clk,
    input rst_n,
    input i_trig,
    input i_idle,
    input us_tick,
    output trig_done
);

reg r_trig_sig;
reg r_trig_done;
reg [3:0] r_us_tick_cnt;

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        r_us_tick_cnt <= 0;
    end else if (us_tick == 1) begin
        r_us_tick_cnt <= r_us_tick_cnt + 1;
    end else if (i_idle == 1) begin
        r_us_tick_cnt <= 0;
    end
end

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        r_trig_sig <= 0;
        r_trig_done <= 0;
    end else if (i_trig == 1) begin
        if (r_us_tick_cnt == 9) begin
            r_trig_sig <= 0;
            r_trig_done <= 1;
        end else begin
            r_trig_sig <= 1;
            r_trig_done <= 0;
        end
    end else if (i_idle == 1) begin
        r_trig_sig <= 0;
        r_trig_done <= 0;
    end else begin
        r_trig_sig <= 0;
        r_trig_done <= 0;
    end
end

assign trigger = r_trig_sig;
assign trig_done = r_trig_done;

endmodule