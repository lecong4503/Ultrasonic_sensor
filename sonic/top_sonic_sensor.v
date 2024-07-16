`timescale 1ns / 1ps

module top_sonic_sensor (
    input clk,
    input rst_n,
    input echo,
    input btn,
    output trigger,
    output [31:0] distance,
    output o_valid
);

wire w_dis_done;
wire w_done_read;
wire w_re_idle;

// TIME_GEN
wire w_us_tick, w_ms_tick;
wire w_toggle;

top_time_gen u_time_gen (
    .clk(clk),
    .rst_n(rst_n),
    .btn(btn),
    .us_tick(w_us_tick),
    .ms_tick(w_ms_tick),
    .toggle(w_toggle)
);

// FSM
wire w_trig_done;
wire w_ot_read;
wire w_idle, w_trig_state, w_measure;

FSM u_FSM (
    .clk(clk),
    .rst_n(rst_n),
    .trig_done(w_trig_done),
    .i_read(w_dis_done),
    .i_done(w_done_read),
    .re_idle(w_re_idle),
    .toggle(w_toggle),
    .ms_tick(w_ms_tick),
    .o_idle(w_idle),
    .o_trigger(w_trig_state),
    .o_measure(w_measure),
    .o_read(w_ot_read)
);

// TRIGGER
trigger u_trig(
    .clk(clk),
    .rst_n(rst_n),
    .i_trig(w_trig_state),
    .i_idle(w_idle),
    .us_tick(w_us_tick),
    .trig_done(w_trig_done)
);

assign trigger = w_trig_state;

// ECHO
wire [31:0] w_echo_time;
wire w_e_done;

echo_time u_echo (
    .clk(clk),
    .rst_n(rst_n),
    .echo(echo),
    .i_idle(w_idle),
    .echo_time(w_echo_time),
    .e_done(w_e_done),
    .re_idle(w_re_idle)
);

// DISTANCE
wire [31:0] w_distance;

distance u_dist(
    .clk(clk),
    .rst_n(rst_n),
    .echo_time(w_echo_time),
    .e_done(w_e_done),
    .i_idle(w_idle),
    .distance(w_distance),
    .dis_done(w_dis_done)
);

// READ

read u_read (
    .clk(clk),
    .rst_n(rst_n),
    .i_distance(w_distance),
    .i_idle(w_idle),
    .i_read(w_ot_read),
    .done_read(w_done_read),
    .distance(distance)
);

assign o_valid = w_done_read;

endmodule