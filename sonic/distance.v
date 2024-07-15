`timescale 1ns / 1ps

module distance (
    input clk,
    input rst_n,
    input [32:0] echo_time,
    input e_done,
    input i_idle,
    output [32:0] distance,
    output dis_done
);

reg r_dis_done;
reg [32:0] r_distance;
wire [32:0] w_distance;

assign w_distance = echo_time / 58;

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        r_distance <= 0;
        r_dis_done <= 0;
    end else if (e_done == 1) begin
        r_distance <= w_distance;
        r_dis_done <= 1;
    end else if (i_idle == 1) begin
        r_dis_done <= 0;
        r_distance <= 0;
    end
end

assign distance = r_distance;
assign dis_done = r_dis_done;

endmodule