`timescale 1ns / 1ps

module read (
    input clk,
    input rst_n,
    input [32:0] i_distance,
    input i_idle,
    input i_read,
    output done_read,
    output [32:0] distance
);

reg [32:0] r_distance;
reg r_done_read;

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        r_distance <= 0;
        r_done_read <= 0;
    end else if (i_read == 1) begin
        r_distance <= i_distance;
        r_done_read <= 1;
    end else if (i_idle == 1) begin
        r_distance <= 0;
        r_done_read <= 0;
    end
end

assign distance = r_distance;
assign done_read = r_done_read;

endmodule