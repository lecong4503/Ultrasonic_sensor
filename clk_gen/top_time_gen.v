`timescale 1ns / 1ps

module top_time_gen (
    input clk,
    input rst_n,
    input btn,
    output us_tick,
    output ms_tick,
    output toggle
);

reg btn_state;
reg toggle_sig;

wire w_run;
wire w_idle;

// toggle_sig gen
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        toggle_sig <= 0;
        btn_state <= 0;
    end else begin
        if (btn && !btn_state) begin
            toggle_sig <= !toggle_sig;
        end
        btn_state <= btn;
    end
end

control u_control (
    .clk(clk),
    .rst_n(rst_n),
    .toggle(toggle_sig),
    .o_idle(w_idle),
    .o_run(w_run)
);

time_gen u_time_gen (
    .clk(clk),
    .rst_n(rst_n),
    .i_idle(w_idle),
    .i_run(w_run),
    .us_tick(us_tick),
    .ms_tick(ms_tick)
);

assign toggle = toggle_sig;

endmodule