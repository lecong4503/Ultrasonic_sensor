`timescale 1ns / 1ps

module FSM(
    input clk,
    input rst_n,
    input us_cnt,
    input ms_cnt,
    output o_idle,
    output o_trigger,
    output o_measure,
    output o_write
);

parameter IDLE = 2'b00;
parameter TRIGGER = 2'b01;
parameter MEASURE = 2'b10;
parameter WRITE = 2'b11;

reg [1:0] c_state, n_state;

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        c_state <= IDLE;
    end else begin
        c_state <= n_state;
    end
end

always @ (*) begin
    case (c_state)
        IDLE : if(ms_cnt == 50)
                n_state = TRIGGER;
        TRIGGER : if(us_cnt == 10)
                n_state = MEASURE;
        MEASURE : if(echo_cnt)

endmodule